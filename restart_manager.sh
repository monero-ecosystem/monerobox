#echo "Stopping manager container......"
docker-compose -f /home/rock64/monerobox/settings/manager.yml down
#echo "Stopping web container......"
docker-compose -f /home/rock64/monerobox/settings/web.yml down

cd /home/rock64/monerobox
./start_manager.sh
