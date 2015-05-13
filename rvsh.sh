#!/bin/bash
programname=$0

function usage {
    echo "usage: $programname [-option] [nom_machine] [nom_utlisateur]"
    echo "  -connect    Le mode connect permet à un utilisateur de se connecter à une machine virtuelle"
    echo "  -admin      Cette commande permet à l’administrateur de gérer la liste des machines connectées au réseau virtuel"
    echo "              et la liste des utilisateurs. Lorsque que la commande admin est saisi il n'y a pas besoin de saisir le nom d'utilisateur"
    echo "              et le nom de la machine"
    echo "  -help       affiche de l'aide"
    exit 1
}
function admin {
    echo "Fonction administrateur"
}
function connect {
    echo "Focntion connect"
}

if [ $1 == "-admin" ]; then
    admin
elif [ $1 == "-connect" ]; then
    connect
else
    usage
fi
