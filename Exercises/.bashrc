# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Keep these for everything but Big Data workshop
# Comment out for that one
module swap intel pgi

PATH=$PATH:./
