#!/bin/bash
#pdjango -f="MJD" -p="mjd" -sp -g -d -rp --git -es
proyecto=''
folder=''
#Nombre tab de terminal base, desde donde ejecuto script
wmctrl -r :ACTIVE: -N "Base"
#Obtengo los nombres de carpeta y proyecto
for i in "$@"
do 
echo $i
case $i in
	-f=* | --folder=*)
		path="${i#*=}"
		echo "Se define carpeta"
		echo $path
		export $path
	;;
	-p=* | --proyecto=*)
		project="${i#*=}"
		echo "Se define proyecto"
		echo $path
		export $path
	;;
esac
done 

echo "variables principales"
echo $project
echo $path
source ~/.profile
workon $project
project_folder=~/Proyectos/$path/web/sitio
cd $project_folder/$project

#ejecuto cada aplicación en nueva terminal: server, gulp, shell, git, sphinx

for i in "$@"
do
option=$i
case $i in
	-s | --shell | -sp | --shell_plus)	
		case $option in
			-s | --shell)
				shell='shell'
				;;
			-sp | --shell_plus)
				shell='shell_plus'
				;;
		esac
		echo "Tipo de shell"
		echo $option
		echo $shell		
		mate-terminal -t "Shell" --tab --working-directory=$project_folder/$project --command="bash -c 'source ~/.profile;workon $project;python manage.py $shell';bash"		
	;;
	
	-g | --gulp)
	mate-terminal -t "Gulp" --tab --working-directory=$project_folder --command="bash -c 'source ~/.profile;workon $project;gulp';bash"
	;;
	-d | --document )
		document_autobuild="sphinx-autobuild --port 9999 source build/html"
		echo $project_folder/documentacion
		mate-terminal -t "Documentacion" --tab --working-directory="/home/david/Proyectos/MJD/web/sitio/documentacion" --command="bash -c 'source ~/.profile;workon $project;$document_autobuild';bash"
	;;
	-r | --runserver | -rp | --runserver_plus )		
		case $i in
			-r | --runserver)
				server='runserver'
				;;
			-rp | --runserver_plus)
				server='runserver_plus'
				;;
		esac
		mate-terminal -t "Server" --tab --working-directory=$project_folder/$project  --command="bash -c 'source ~/.profile;workon $project;python manage.py $server';bash"
		;;	
	-e | --git )
		mate-terminal -t "Git" --tab --working-directory=$project_folder  --command="bash -c 'source ~/.profile;workon $project;git status';bash"
	;;
	-es | --elasticsearch )
		mate-terminal -t "ElasticSearch" --tab --working-directory=$project_folder  --command="bash -c 'source ~/.profile;workon $project;elasticsearch'; bash"
	;;
esac
done



