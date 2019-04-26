# Individually builds and publishes all components
# Run from repo's root folder
# pushd Users
# docker build -t comosamples/bikesharing/users .
# como publish comosamples/users
# popd

declare -a arr=("BikeSharingWeb" "Gateway" "Bikes" "Users" "Reservation" "ReservationEngine" "Billing")
for i in "${arr[@]}"
do
    pushd $i
    i=$(echo $i | tr '[:upper:]' '[:lower:]')
    echo "******************************************"
    echo "******************************************"
    echo "** BUILDING $i"
    echo "******************************************"
    docker build -t comosamples/bikesharing-$i .
    echo "******************************************"
    echo "******************************************"
    echo "** PUBLISHING $i"
    echo "******************************************"
    como publish comosamples/bikesharing-$i
    popd
done