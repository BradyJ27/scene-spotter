import os
import argparse
import requests
from bs4 import BeautifulSoup


def parse_args():
    parser = argparse.ArgumentParser(
        prog="ScrapeShillpages",
        description="Program that scrapes image title screens from Shillpages",
    )
    parser.add_argument("output", help="Directory to output images to")
    parser.add_argument(
        "-d", "--decade", nargs="+", help="Decade(s) to get movie title screens from"
    )

    args = parser.parse_args()
    return args


def get_images(output_dir, decade):
    url = f"https://www.shillpages.com/movies/mt{decade}s.shtml"
    response = requests.get(url)
    html_content = response.content
    soup = BeautifulSoup(html_content, "html.parser")
    image_links = soup.find_all("a", href=True)
    images = [a["href"] for a in image_links if a.find("img")]
    base_url = "https://www.shillpages.com/movies/"

    for img in images:
        img_url = img
        if not img_url.startswith("http"):
            img_url = base_url + img_url

        img_data = requests.get(img_url).content
        img_name = img_url.split("/")[-1]
        full_file = os.path.join(output_dir, img_name)

        with open(full_file, "wb") as handler:
            handler.write(img_data)


def main():
    args = parse_args()
    decades = args.decade
    output_dir = args.output

    for decade in decades:
        get_images(output_dir, decade)


if __name__ == "__main__":
    main()
