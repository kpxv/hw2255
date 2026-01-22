#! /bin/sh

deskew -o out-deskew.png prelab.png
magick out-deskew.png -colorspace Gray -density 300 out-magick.pbm
unpaper out-magick.pbm out-unpaper.pdf
tesseract out-unpaper.pdf stdout pdf > prelab.pdf

rm out*
