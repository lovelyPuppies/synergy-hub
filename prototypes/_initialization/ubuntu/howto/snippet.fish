## 🌀 Title: View Standard Output in VS Code 📅 2024-12-12 00:52:53
##  Format: <stdout> > /tmp/out.txt; and code /tmp/out.txt
# 🛍️ e.g.
man systemctl >/tmp/man.txt 2>&1; and code /tmp/man.txt


## 🌀 Title: open .tex file 📅 2024-09-12 00:45:30
code **/*.tex
##  🌀 Title: replace all .tex file with .txt file 📅 2024-09-12 00:45:30
for file in **/*.tex
    mv $file (string replace .tex .txt $file)
end
