import datetime

from pyhafas import HafasClient
from pyhafas.profile import RKRPProfile

# Human input strings
id_nordhavn = 'Nordhavn St.'
id_kildedal = 'Kildedal St.'
id_maalev = 'Måløv St.'
id_kongebakken9 = 'Kongebakken 9, 2765 Smørum'


def print_departures(deps):
    for d in deps:
        if d.cancelled:
            continue
        if "Frederikssund" in d.direction:
            continue  # We want towards Copenhagen
        t_dep = d.dateTime + datetime.timedelta(seconds = d.delay.total_seconds() if d.delay else 0)
        print(t_dep.strftime('%H:%M'), d.name, d.station.name, "towards", d.direction) 

def main():
    client = HafasClient(RKRPProfile(), debug=True)

    # Resolve human string into Location-ID
    lids_kongebakken9 = client.locations(id_kongebakken9, rtype='ALL')
    lid_kongebakken9 = lids_kongebakken9[0].lid  # First is good-enough
    assert('Kongebakken 9, 2765 Smørum, Egedal Kommune' in lid_kongebakken9)

    lids_nordhavn = client.locations(id_nordhavn, rtype='ALL')
    lid_nordhavn = lids_nordhavn[0].lid  # First is good-enough
    assert('Nordhavn St' in lid_nordhavn)

    lids_kildedal = client.locations(id_kildedal, rtype='ALL')
    lid_kildedal = lids_kildedal[0].lid  # First is good-enough
    assert('Kildedal St' in lid_kildedal)

    lids_maalev = client.locations(id_maalev, rtype='ALL')
    lid_maalev = lids_maalev[0].lid  # First is good-enough
    assert('Måløv St' in lid_maalev)

    just_now = datetime.datetime.now()
    dep_kildedal = client.departures(station=lid_kildedal, date=just_now, max_trips=5)
    dep_maalev = client.departures(station=lid_maalev, date=just_now, max_trips=5)

    deps = dep_kildedal + dep_maalev
    deps = sorted(deps, key=lambda d: d.dateTime)

    print_departures(deps)


if __name__ == '__main__':
    main()
