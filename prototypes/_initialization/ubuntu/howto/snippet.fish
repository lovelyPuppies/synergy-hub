## 🌀 Title: open .tex file 📅 2024-09-12 00:45:30
code **/*.tex
##  🌀 Title: replace all .tex file with .txt file 📅 2024-09-12 00:45:30
for file in **/*.tex
    mv $file (string replace .tex .txt $file)
end
