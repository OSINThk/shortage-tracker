let map = L.map("map-container").setView([22.27583223, 114.154832714], 13);
L.tileLayer("https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png", {
  attribution:
    'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery by Wikimedia Foundation ',
  maxZoom: 18,
  setView: true
}).addTo(map);

const coordinates = [
  { lat: "22.2276", lng: "114.2178" }, // American club
  //{ lat: "22.392998428", lng: "114.203999184" }, // horse racing
  "22.274665568 114.155666044"
];
let handleResize = () => {
  fetch("/maptest?lat=114.029&lon=22.344&dist=15000&since=2020-01-01")
    .then(response => {
      return response.json();
    })
    .then(json => {
      json.forEach(item => {
        L.marker(coordinates[0])
          .addTo(map)
          .bindPopup(item["notes"]);
      });
    });
};

// initial pin loads
handleResize();

// Handle resize events!
map.on("zoomend", handleResize);
map.on("dragend", handleResize);
map.on("resize", handleResize);
