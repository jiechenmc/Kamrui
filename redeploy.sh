cd loqi
./sync.sh
cd ..
docker compose down
docker compose up --build -d
