import os
import argparse
import requests
from bs4 import BeautifulSoup


def parse_args():
    parser = argparse.ArgumentParser(
        prog="ScrapeFilmsite",
        description="Program that scrapes image title screens from Filmsite",
    )
    parser.add_argument("output", help="Directory to output images to")
    parser.add_argument(
        "-y", "--years", nargs="+", help="Year(s) to get movie title screens from"
    )

    args = parser.parse_args()
    return args


def get_images(output_dir, year):
    url = f"https://www.filmsite.org/titles-{year}.html"
    response = requests.get(url)
    html_content = response.content
    soup = BeautifulSoup(html_content, "html.parser")
    images = soup.select("table img")
    base_url = "https://www.filmsite.org/"

    for img in images:
        img_url = img.get("src")
        if not img_url.startswith("http"):
            img_url = base_url + img_url

        img_data = requests.get(img_url).content
        img_name = img_url.split("/")[-1]
        full_file = os.path.join(output_dir, img_name)

        with open(full_file, "wb") as handler:
            handler.write(img_data)


def main():
    args = parse_args()
    years = args.years
    output_dir = args.output

    for year in years:
        get_images(output_dir, year)


if __name__ == "__main__":
    main()
