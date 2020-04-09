/*L.tileLayer(
  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=" +
    "sk.eyJ1Ijoib3NpbnRoayIsImEiOiJjazZkYWRueHEwNTRkM2VtdmNnZWwwbmV4In0.B42ECPkQldyVNtvTplkY3A",
  {
    attribution:
      '© <a href="https://www.mapbox.com/feedback/">Mapbox</a> © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 18,
    setView: true
  }
).addTo(map);*/
const tileUrl = 'https://api.mapbox.com/styles/v1/john-525/ck8sgtdwd0ij11is59scz4kar/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoiam9obi01MjUiLCJhIjoiY2s4c2dsM2dhMGZ2bTNsbGoyNGViZ3FvZiJ9.IAIhKh1bJxHnXGU_toe-sQ';
const attribution = '© <a href="https://www.mapbox.com/feedback/">Mapbox</a> © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>';

L.tileLayer(tileUrl, { attribution, maxZoom: 18, setView: true }).addTo(map);

// Position the zoomcontrol where we want it
L.control 
  .zoom({
    position: "topright"
  })
  .addTo(map);

var displayed = new Set();
var cursors = new Set();

let handleLoad = () => {
  var bounds = map.getBounds();
  var coord0 = bounds.getNorthWest();
  var coord1 = bounds.getSouthEast();

  var querystring = {
    x0: coord0.lng,
    y0: coord0.lat,
    x1: coord1.lng,
    y1: coord1.lat
  };

  var url =
    "/results.json?" +
    Object.entries(querystring)
      .map(kvpair => kvpair.join("="))
      .join("&");
  if (cursors.size) {
    url +=
      "&" +
      [...cursors.values()].map(cursor => `cursors[]=${cursor}`).join("&");
  }

  fetch(url)
    .then(response => {
      return response.json();
    })
    .then(json => {
      cursors.add(json.meta.cursor);
      json.meta.parents.forEach(cursor => cursors.delete(cursor));

      json.results.forEach(report => {
        if (displayed.has(report.id)) {
          return;
        }

        displayed.add(report.id);

        popup = document.createElement("div");
        popup.style.maxHeight = "300px";
        popup.style.overflowX = "auto";

        reportNotes = document.createElement("p");
        reportNotes.appendChild(document.createTextNode(report.notes));
        popup.appendChild(reportNotes);

        report.product_detail.forEach(product => {
          productName = document.createElement("h5");
          productName.appendChild(
            document.createTextNode(product.product.name)
          );
          popup.appendChild(productName);

          productScarcity = document.createElement("p");
          productScarcity.appendChild(
            document.createTextNode(`${localization.product.scarcity}: ${product.scarcity}`)
          );
          popup.appendChild(productScarcity);

          productPrice = document.createElement("p");
          productPrice.appendChild(
            document.createTextNode(`${localization.product.price}: ${product.price}`)
          );
          popup.appendChild(productPrice);

          productNotes = document.createElement("p");
          productNotes.appendChild(document.createTextNode(product.notes));
          popup.appendChild(productNotes);

          reportTime = document.createElement("h6");
          reportTime.appendChild(document.createTextNode(report.created_at)); 
          popup.appendChild(reportTime);
        });

        L.marker([report.lat, report.long])
          .addTo(map)
          .bindPopup(popup);
      });
    });
};

// initial pin loads
handleLoad();

// Handle resize events!
map.on("zoomend", handleLoad);
map.on("dragend", handleLoad);
map.on("resize", handleLoad);

function redirectToReport(event) {
  // Capture any locale.
  let path = window.location.pathname.replace(/\/*$/, '');
  let reportsPath = `${path}/reports/new`;

  // Capture any querystring.
  let querystring = window.location.search;
  let addition = `lat=${event.latlng.lat}&long=${event.latlng.lng}`;
  if (querystring.length) {
    output = `${querystring}&${addition}`
  } else {
    output = `?${addition}`
  }

  // Head on.
  window.location = `${reportsPath}${output}`;
}

// Handle clicking.
map.on("click", redirectToReport);
