#!/usr/bin/env python3
import requests
from PIL import Image
import os

book = {
  "chapter1": {
    "url": ("https://node2d-public.hep.com.cn/"
            "579c75d5b7ce5471acf4396725a6b329.pdf_files/"
            "579c75d5b7ce5471acf4396725a6b329.pdf.files/"),
    "page": 34
  },
  "chapter2": {
    "url": ("https://node2d-public.hep.com.cn/"
            "bee06dd3d87274890b5ec41c9361c17c.pdf_files/"
            "bee06dd3d87274890b5ec41c9361c17c.pdf.files/"),
    "page": 37
  },
  "chapter3": {
    "url": ("https://node2d-public.hep.com.cn/"
            "33b996b6ac2afe46c22db6a17025b620.pdf_files/"
            "33b996b6ac2afe46c22db6a17025b620.pdf.files/"),
    "page": 31
  }
}

pages = []

for chapter_name, chapter_content in book.items():
    os.mkdir(chapter_name)
    for i in range(1, 1 + int(chapter_content["page"])):
        print("Requesting: ", chapter_name, ", page ", i)
        url = chapter_content["url"] + str(i) + ".png"
        print("Url:", url)
        r = requests.get(url, allow_redirects=True)
        saved_path = "/tmp/simple_physics_images" + chapter_name + \
                     "/" + str(i) + ".png"
        open(saved_path, "wb").write(r.content)
        img = Image.open(saved_path)
        im = img.convert('RGBA')
        if im.mode in ('RGBA', 'LA'):
            background = Image.new(im.mode[:-1], im.size, (255, 255, 255))
            background.paste(im, im.split()[-1])
            im = background
        pages.append(im)

first_page = pages.pop(0)
first_page.save("简明物理学教程(第一至三章).pdf",
                save_all=True,
                append_images=pages)
