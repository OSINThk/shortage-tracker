function findMe() {
  function success(position) {
    var { latitude, longitude, altitude, accuracy, altitudeAccuracy, heading, speed } = position.coords;
    document.getElementById('report_lat').value = latitude;
    document.getElementById('report_long').value = longitude;
    // alert(JSON.stringify({ latitude, longitude, altitude, accuracy, altitudeAccuracy, heading, speed }));
  }

  function error(error) {
    alert(error.message);
  }

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(success, error);
  } else {
    alert('Your browser does not support geolocation.')
  }
}

document.addEventListener('click', function(event) {
  if (event.target.nodeName.toLowerCase() === "button") {
    if (event.target.classList.contains('find-me')) {
      findMe(event);
    }
  }
});
