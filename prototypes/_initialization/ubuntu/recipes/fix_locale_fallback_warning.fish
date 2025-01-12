#!/usr/bin/env fish

' ❓ perl: warning: Setting locale failed.
  Whenever `sudo apt install ..` or `perl -e exit`, it prints:
  >> 
    perl: warning: Please check that your locale settings:
        LANGUAGE = (unset),
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
      are supported and installed on your system.
    perl: warning: Falling back to the standard locale ("C").
  
  %shell> apt-cache policy locales
  >> locales:
    Installed: (none)
    Candidate: 2.36-9+deb12u9
    Version table:
      2.36-9+deb12u9 500
          500 http://deb.debian.org/debian bookworm/main amd64 Packages
      2.36-9+deb12u7 500
          500 http://deb.debian.org/debian-security bookworm-security/main amd64 Packages

  ❔ command `localedef`
    Input Files:
      -f, --charmap=FILE         Symbolic character names defined in FILE
      -i, --inputfile=FILE       Source definitions are found in FILE
  
  ➡️ sudo apt install -y locales && localedef -i en_US -f UTF-8 en_US.UTF-8 
'
sudo apt install -y locales && sudo localedef -i en_US -f UTF-8 en_US.UTF-8
