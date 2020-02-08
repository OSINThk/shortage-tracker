L.tileLayer(
  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=" +
    process.env.MAPBOX_API_KEY,
  {
    attribution:
      '© <a href="https://www.mapbox.com/feedback/">Mapbox</a> © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 18,
    setView: true
  }
).addTo(map);

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
        reportTime = document.createElement("h6");
        reportTime.appendChild(document.createTextNode(report.created_at));
        popup.appendChild(reportTime);

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
            document.createTextNode(`Scarcity: ${product.scarcity}`)
          );
          popup.appendChild(productScarcity);

          productPrice = document.createElement("p");
          productPrice.appendChild(
            document.createTextNode(`Price: ${product.price}`)
          );
          popup.appendChild(productPrice);

          productNotes = document.createElement("p");
          productNotes.appendChild(document.createTextNode(product.notes));
          popup.appendChild(productNotes);
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
  window.location = `/reports/new?lat=${event.latlng.lat}&long=${event.latlng.lng}`;
}

// Handle clicking.
map.on("click", redirectToReport);
