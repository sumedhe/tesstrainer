
#!/bin/bash

# Tessdata Download
# osd	Orientation and script detection
wget -O ${TESSDATA_PREFIX}/osd.traineddata https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata
# equ	Math / equation detection
wget -O ${TESSDATA_PREFIX}/equ.traineddata https://github.com/tesseract-ocr/tessdata/raw/3.04.00/equ.traineddata
# eng English
wget -O ${TESSDATA_PREFIX}/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/4.00/eng.traineddata
# sin Sinhala
wget -O ${TESSDATA_PREFIX}/sin.traineddata https://github.com/tesseract-ocr/tessdata/raw/4.00/sin.traineddata
# other languages: https://github.com/tesseract-ocr/tesseract/wiki/Data-Files
