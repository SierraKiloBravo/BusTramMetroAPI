# A dirty script to download kv7 data from kv7.openov.nl, to prevent having to wait (up to a week) for complete timetable data over ZMQ

mkdir -p kv78dl/KV7calendar
mkdir -p kv78dl/KV7planning

# Download calendar messages
wget -P kv78dl/KV7calendar/ $(curl http://kv7.openov.nl/GOVI/KV7calendar/ |   grep -io '<a class=\"link\" href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a class=\"link\" href=["'"'"']//i' -e 's/["'"'"']$//i' -e 's/..\///' -e '/^\s*$/d' -e 's/^/http:\/\/kv7.openov.nl\/GOVI\/KV7calendar\//')

# Download planning messages, only the last 2500 as kv7.openov.nl/GOVI/KV7planning goes back to 2018 which is completely unnecessary
wget -P kv78dl/KV7planning/ $(cat curl http://kv7.openov.nl/GOVI/KV7planning/ |   grep -io '<a class=\"link\" href=['"'"'"][^"'"'"']*['"'"'"]' |   sed -e 's/^<a class=\"link\" href=["'"'"']//i' -e 's/["'"'"']$//i' -e 's/^/http:\/\/kv7.openov.nl\/GOVI\/KV7planning\//' | tail -n1500)

# decompress messages
gunzip kv78dl/KV7calendar/*.gz
gunzip kv78dl/KV7planning/*.gz

# import kv7calendar first, followed by kv7planning
for file in kv78dl/KV7calendar; do
import_single_message.py $file
done

for file in kv78dl/KV7planning; do
import_single_message.py $file
done
