// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

let Hooks = {};
Hooks.Map = {
  mounted() {
    const input1 = document.getElementById("location1");
    const input2 = document.getElementById("location2");
    const latitude_from_input = document.getElementById("latitude_from_input");
    const longitude_from_input = document.getElementById(
      "longitude_from_input"
    );
    const latitude_to_input = document.getElementById("latitude_to_input");
    const longitude_to_input = document.getElementById("longitude_to_input");
    const options = {
      fields: ["address_components", "geometry", "icon", "name"],
      componentRestrictions: { country: "ke" },
    };

    const autocomplete1 = new google.maps.places.Autocomplete(input1, options);
    autocomplete1.addListener("place_changed", () => {
      const place1 = autocomplete1.getPlace();
      console.log(place1.geometry.location.lat());
      latitude_from_input.value = place1.geometry.location.lat();
      longitude_from_input.value = place1.geometry.location.lng();
    });

    const autocomplete2 = new google.maps.places.Autocomplete(input2, options);
    autocomplete2.addListener("place_changed", () => {
      const place2 = autocomplete2.getPlace();
      console.log(place2.geometry.location.lat());
      latitude_to_input.value = place2.geometry.location.lat();
      longitude_to_input.value = place2.geometry.location.lng();
    });
  },
  updated() {
    const input1 = document.getElementById("location1");
    const input2 = document.getElementById("location2");
    const latitude_from_input = document.getElementById("latitude_from_input");
    const longitude_from_input = document.getElementById(
      "longitude_from_input"
    );
    const latitude_to_input = document.getElementById("latitude_to_input");
    const longitude_to_input = document.getElementById("longitude_to_input");
    const options = {
      fields: ["address_components", "geometry", "icon", "name"],
      componentRestrictions: { country: "ke" },
    };

    const autocomplete1 = new google.maps.places.Autocomplete(input1, options);
    autocomplete1.addListener("place_changed", () => {
      const place1 = autocomplete1.getPlace();
      console.log(place1.geometry.location.lat());
      latitude_from_input.value = place1.geometry.location.lat();
      longitude_from_input.value = place1.geometry.location.lng();
    });

    const autocomplete2 = new google.maps.places.Autocomplete(input2, options);
    autocomplete2.addListener("place_changed", () => {
      const place2 = autocomplete2.getPlace();
      console.log(place2.geometry.location.lat());
      latitude_to_input.value = place2.geometry.location.lat();
      longitude_to_input.value = place2.geometry.location.lng();
    });
  },
};

Hooks.MapBox = {
  mounted() {
    function initMap() {
      const directionsRenderer = new google.maps.DirectionsRenderer();
      const directionsService = new google.maps.DirectionsService();
      const origin_latitude = Number(
        document.getElementById("origin_latitude").innerHTML
      );
      const origin_longitude = Number(
        document.getElementById("origin_longitude").innerHTML
      );

      const destination_latitude = Number(
        document.getElementById("destination_latitude").innerHTML
      );
      const destination_longitude = Number(
        document.getElementById("destination_longitude").innerHTML
      );

      const map = new google.maps.Map(document.getElementById("mapbox"), {
        zoom: 14,
        center: { lat: origin_latitude, lng: origin_longitude },
      });

      directionsRenderer.setMap(map);
      directionsRenderer.setPanel(document.getElementById("sidebar"));

      calculateAndDisplayRoute(directionsService, directionsRenderer);
    }

    function calculateAndDisplayRoute(directionsService, directionsRenderer) {
      const origin_latitude = Number(
        document.getElementById("origin_latitude").innerHTML
      );
      const origin_longitude = Number(
        document.getElementById("origin_longitude").innerHTML
      );

      const destination_latitude = Number(
        document.getElementById("destination_latitude").innerHTML
      );
      const destination_longitude = Number(
        document.getElementById("destination_longitude").innerHTML
      );

      // Set the travel mode to "DRIVING" explicitly
      const selectedMode = "DRIVING";
      const all_waypoints = document.querySelectorAll(".waypoints");

      all_waypoints.forEach((waypoint) => {
        console.log(waypoint.firstElementChild.nextElementSibling.innerHTML);
        console.log(waypoint.lastElementChild.previousElementSibling.innerHTML);
      });

      let waypointArray = [];

      all_waypoints.forEach((waypoint) => {
        waypointArray.push(
          {
            location: {
              lat: Number(waypoint.firstElementChild.innerHTML),
              lng: Number(
                waypoint.firstElementChild.nextElementSibling.innerHTML
              ),
            },
            stopover: true,
          },
          {
            location: {
              lat: Number(
                waypoint.lastElementChild.previousElementSibling.innerHTML
              ),
              lng: Number(waypoint.lastElementChild.innerHTML),
            },
            stopover: true,
          }
        );
      });

      directionsService
        .route({
          origin: {
            lat: origin_latitude,
            lng: origin_longitude,
          },
          destination: {
            lat: destination_latitude,
            lng: destination_longitude,
          },
          waypoints: waypointArray,

          travelMode: google.maps.TravelMode[selectedMode],
        })
        .then((response) => {
          directionsRenderer.setDirections(response);
        })
        .catch((e) =>
          window.alert("Directions request failed due to " + status)
        );
    }

    initMap();
  },
  updated() {
    function initMap() {
      const directionsRenderer = new google.maps.DirectionsRenderer();
      const directionsService = new google.maps.DirectionsService();
      const origin_latitude = Number(
        document.getElementById("origin_latitude").innerHTML
      );
      const origin_longitude = Number(
        document.getElementById("origin_longitude").innerHTML
      );

      const destination_latitude = Number(
        document.getElementById("destination_latitude").innerHTML
      );
      const destination_longitude = Number(
        document.getElementById("destination_longitude").innerHTML
      );

      const map = new google.maps.Map(document.getElementById("mapbox"), {
        zoom: 14,
        center: { lat: origin_latitude, lng: origin_longitude },
      });

      directionsRenderer.setMap(map);
      directionsRenderer.setPanel(document.getElementById("sidebar"));

      calculateAndDisplayRoute(directionsService, directionsRenderer);
    }

    function calculateAndDisplayRoute(directionsService, directionsRenderer) {
      const origin_latitude = Number(
        document.getElementById("origin_latitude").innerHTML
      );
      const origin_longitude = Number(
        document.getElementById("origin_longitude").innerHTML
      );

      const destination_latitude = Number(
        document.getElementById("destination_latitude").innerHTML
      );
      const destination_longitude = Number(
        document.getElementById("destination_longitude").innerHTML
      );

      // Set the travel mode to "DRIVING" explicitly
      const selectedMode = "DRIVING";
      const all_waypoints = document.querySelectorAll(".waypoints");

      all_waypoints.forEach((waypoint) => {
        console.log(waypoint.firstElementChild.nextElementSibling.innerHTML);
        console.log(waypoint.lastElementChild.previousElementSibling.innerHTML);
      });

      let waypointArray = [];

      all_waypoints.forEach((waypoint) => {
        waypointArray.push(
          {
            location: {
              lat: Number(waypoint.firstElementChild.innerHTML),
              lng: Number(
                waypoint.firstElementChild.nextElementSibling.innerHTML
              ),
            },
            stopover: true,
          },
          {
            location: {
              lat: Number(
                waypoint.lastElementChild.previousElementSibling.innerHTML
              ),
              lng: Number(waypoint.lastElementChild.innerHTML),
            },
            stopover: true,
          }
        );
      });

      directionsService
        .route({
          origin: {
            lat: origin_latitude,
            lng: origin_longitude,
          },
          destination: {
            lat: destination_latitude,
            lng: destination_longitude,
          },
          waypoints: waypointArray,

          travelMode: google.maps.TravelMode[selectedMode],
        })
        .then((response) => {
          directionsRenderer.setDirections(response);
        })
        .catch((e) =>
          window.alert("Directions request failed due to " + status)
        );
    }

    initMap();
  },
};

Hooks.Location = {
  mounted() {
    const input1 = document.getElementById("booking_input1");
    const input2 = document.getElementById("booking_input2");
    const latitude_from_input = document.getElementById(
      "booking_latitude_from_input"
    );
    const longitude_from_input = document.getElementById(
      "booking_longitude_from_input"
    );
    const latitude_to_input = document.getElementById(
      "booking_latitude_to_input"
    );
    const longitude_to_input = document.getElementById(
      "booking_longitude_to_input"
    );
    const options = {
      fields: ["address_components", "geometry", "icon", "name"],
      componentRestrictions: { country: "ke" },
    };

    const autocomplete1 = new google.maps.places.Autocomplete(input1, options);
    autocomplete1.addListener("place_changed", () => {
      const place1 = autocomplete1.getPlace();
      console.log(place1.geometry.location.lat());
      latitude_from_input.value = place1.geometry.location.lat();
      longitude_from_input.value = place1.geometry.location.lng();
    });

    const autocomplete2 = new google.maps.places.Autocomplete(input2, options);
    autocomplete2.addListener("place_changed", () => {
      const place2 = autocomplete2.getPlace();
      console.log(place2.geometry.location.lat());
      latitude_to_input.value = place2.geometry.location.lat();
      longitude_to_input.value = place2.geometry.location.lng();
    });
  },
  updated() {
    const input1 = document.getElementById("booking_input1");
    const input2 = document.getElementById("booking_input2");
    const latitude_from_input = document.getElementById(
      "booking_latitude_from_input"
    );
    const longitude_from_input = document.getElementById(
      "booking_longitude_from_input"
    );
    const latitude_to_input = document.getElementById(
      "booking_latitude_to_input"
    );
    const longitude_to_input = document.getElementById(
      "booking_longitude_to_input"
    );
    const options = {
      fields: ["address_components", "geometry", "icon", "name"],
      componentRestrictions: { country: "ke" },
    };

    const autocomplete1 = new google.maps.places.Autocomplete(input1, options);
    autocomplete1.addListener("place_changed", () => {
      const place1 = autocomplete1.getPlace();
      console.log(place1.geometry.location.lat());
      latitude_from_input.value = place1.geometry.location.lat();
      longitude_from_input.value = place1.geometry.location.lng();
    });

    const autocomplete2 = new google.maps.places.Autocomplete(input2, options);
    autocomplete2.addListener("place_changed", () => {
      const place2 = autocomplete2.getPlace();
      console.log(place2.geometry.location.lat());
      latitude_to_input.value = place2.geometry.location.lat();
      longitude_to_input.value = place2.geometry.location.lng();
    });
  },
};
Hooks.Navbar = {
  mounted() {
    const toggleButton = document.getElementById("toggleButton");
    const sidebar = document.getElementById("sidebar");

    toggleButton.addEventListener("click", () => {
      sidebar.classList.toggle("-translate-x-full");
    });

    document.getElementById("sidebarContent").addEventListener("click", () => {
      sidebar.classList.toggle("-translate-x-full");
    });
  },
};

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});
// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
