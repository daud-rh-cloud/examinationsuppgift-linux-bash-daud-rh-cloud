#!/bin/bash

    # 1 Check if the user is root (UID 0)
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root (use sudo)."
    exit 1
fi

    #2 Loopa igenom alla namn som angetts som argument
for username in "$@"; do
    echo "skapar användare: $username"
    
    #3 Lägg till användaren och skapa deras hemkatalog
    useradd -m "$username"
    mkdir -p /home/"$username"/{Documents,Downloads,Work}

    # 4. Sätt rättigheter 
    chmod 700 /home/"$username"/Documents
    chmod 700 /home/"$username"/Downloads
    chmod 700 /home/"$username"/Work

    #5. Se till att användaren äger sina nya mappar och sin hemkatalog
    chown -R "$username":"$username" /home/"$username"


    # 6.Skapa välkomstmeddelandet
    echo "Välkommen $username" > /home/"$username"/welcome.txt
    
 
     #7.Lista andra mänskliga användare (UID 999-60000) och lägg till i filen
        echo "Other users on this system:" >> /home/"$username"/welcome.txt
        awk -F: '($3 >= 999) && ($3 < 60000) {print $1}' /etc/passwd >> /home/"$username"/welcome.txt
        echo "$@" >> /home/"$username"/welcome.txt
done
    
    echo "Alla användare har skapats framgångsrikt!"

     
  
    
