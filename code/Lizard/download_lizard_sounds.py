#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
import re
import os
import time
import urllib.parse
from pathlib import Path

def get_sound_links():
    """Get all individual sound page links from the search results"""
    url = "https://www.myinstants.com/en/search/?name=lizard"
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }

    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, 'html.parser')

    # Find all links to individual sound pages
    sound_links = []
    for link in soup.find_all('a', href=True):
        href = link['href']
        if '/en/instant/' in href and href.endswith('/'):
            full_url = urllib.parse.urljoin('https://www.myinstants.com', href)
            sound_links.append(full_url)

    return list(set(sound_links))  # Remove duplicates

def get_audio_url_from_page(sound_page_url):
    """Extract the actual audio file URL from an individual sound page"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }

    try:
        response = requests.get(sound_page_url, headers=headers)
        soup = BeautifulSoup(response.content, 'html.parser')

        # Look for audio elements or data attributes that contain the audio URL
        audio_element = soup.find('audio')
        if audio_element and audio_element.get('src'):
            return audio_element['src']

        # Look for JavaScript variables or data attributes
        scripts = soup.find_all('script')
        for script in scripts:
            if script.string:
                # Look for audio URLs in JavaScript
                matches = re.findall(r'https://[^"\']*\.(?:mp3|wav|ogg)', script.string)
                if matches:
                    return matches[0]

        # Look for data attributes on buttons or divs
        for element in soup.find_all(attrs={'data-url': True}):
            data_url = element['data-url']
            if data_url.endswith(('.mp3', '.wav', '.ogg')):
                if not data_url.startswith('http'):
                    data_url = 'https://www.myinstants.com' + data_url
                return data_url

        # Look for onclick handlers that might contain audio URLs
        for element in soup.find_all(attrs={'onclick': True}):
            onclick = element['onclick']
            matches = re.findall(r'https://[^"\']*\.(?:mp3|wav|ogg)', onclick)
            if matches:
                return matches[0]

        return None

    except Exception as e:
        print(f"Error processing {sound_page_url}: {e}")
        return None

def download_audio_file(audio_url, filename):
    """Download an audio file"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }

    try:
        if not audio_url.startswith('http'):
            audio_url = 'https://www.myinstants.com' + audio_url

        response = requests.get(audio_url, headers=headers)
        if response.status_code == 200:
            with open(filename, 'wb') as f:
                f.write(response.content)
            return True
        else:
            print(f"Failed to download {audio_url}: HTTP {response.status_code}")
            return False
    except Exception as e:
        print(f"Error downloading {audio_url}: {e}")
        return False

def sanitize_filename(name):
    """Clean filename for filesystem compatibility"""
    # Remove or replace invalid characters
    name = re.sub(r'[<>:"/\\|?*]', '_', name)
    name = name.strip()
    return name[:50]  # Limit length

def main():
    # Create sounds directory
    sounds_dir = Path('./lizard_sounds')
    sounds_dir.mkdir(exist_ok=True)

    print("Getting sound links...")
    sound_links = get_sound_links()
    print(f"Found {len(sound_links)} sound pages")

    downloaded_files = []

    for i, sound_link in enumerate(sound_links, 1):
        print(f"Processing {i}/{len(sound_links)}: {sound_link}")

        # Get the sound name from URL
        sound_name = sound_link.split('/')[-2].replace('-', ' ').title()

        audio_url = get_audio_url_from_page(sound_link)
        if audio_url:
            # Determine file extension
            ext = '.mp3'  # Default
            if '.wav' in audio_url.lower():
                ext = '.wav'
            elif '.ogg' in audio_url.lower():
                ext = '.ogg'

            filename = sounds_dir / f"{sanitize_filename(sound_name)}{ext}"

            if download_audio_file(audio_url, filename):
                print(f"  ✓ Downloaded: {filename}")
                downloaded_files.append((sound_name, filename))
            else:
                print(f"  ✗ Failed to download: {sound_name}")
        else:
            print(f"  ✗ No audio URL found for: {sound_name}")

        # Be respectful to the server
        time.sleep(1)

    print(f"\nDownload complete! {len(downloaded_files)} files downloaded.")

    # Save list of downloaded files for AutoHotkey script generation
    with open('downloaded_sounds.txt', 'w') as f:
        for name, filepath in downloaded_files:
            f.write(f"{name}|{filepath}\n")

    return downloaded_files

if __name__ == "__main__":
    main()