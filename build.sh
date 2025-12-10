#!/bin/bash
# First convert the pdfs to images of each page for the website

# Do this with imagemagick
magick -density 300 cv/*.pdf -depth 8 -strip -background white -alpha off cv/CV.png
magick -density 300 resume/*.pdf -depth 8 -strip -background white -alpha off resume/Resume.png

rm -rf docs/cv docs/resume
cp -r cv docs/
cp -r resume docs/