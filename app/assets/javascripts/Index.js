function crimemap(mapdata) {
    this.initialize = function() {
        var mapOptions = {
            center: { lat: crimes.center.y, lng: crimes.center.x },
            width: 300,
            height: 300,
            zoom: 15
        };
        var mapApi = google.maps;
        var infowindow = new mapApi.InfoWindow({

        });
        var map = new mapApi.Map(document.getElementById('map-canvas'),
            mapOptions);
        for (var i = 0; i < mapdata.points.length; i++) {
            var currentPoint = crimes.points[i];
            var myLatlng = new mapApi.LatLng(currentPoint.geometry.y, currentPoint.geometry.x);
            var image = getImage(currentPoint.attributes.UCR_GENERAL);
            var marker = new mapApi.Marker({
                position: myLatlng,
                map: map,
                title: currentPoint.attributes.TEXT_GENERAL_CODE,
                icon: image,
                attributes: currentPoint.attributes
            });


            mapApi.event.addListener(marker, 'click', function(event) {
                infowindow.setContent("<div><div style='white-space: nowrap;'>" + this.attributes.LOCATION_BLOCK + "</div>" +
                    "<div style='white-space: nowrap;'>" + this.attributes.TEXT_GENERAL_CODE + "</div>" +
                    "<div style='white-space: nowrap;'>" + this.attributes.DISPATCH_TIME + "</div>" +
                    "<div id='sv' style='width:300px;height:200px;'></div></div>");
                infowindow.setPosition(this.getPosition());
                mapApi.event.addListener(infowindow, 'domready', function() {
                    var panorama = new
                        mapApi.StreetViewPanorama(document.getElementById("sv"));
                    panorama.setPosition(infowindow.getPosition());
                });
                infowindow.open(map, this);
            });
        }

    }

    function getImage(ucrCode) {
        switch (ucrCode) {
        case "100":
            return '/assets/Icons/pin-red-13.png';
        case "200":
            return '/assets/Icons/pin-red-12.png';
        case "300":
            return '/assets/Icons/pin-magenta-13.png';
        case "400":
            return '/assets/Icons/pin-magenta-12.png';
        case "500":
            return '/assets/Icons/pin-yellow-12.png';
        case "600":
            return '/assets/Icons/pin-blue-13.png';
        case "700":
            return '/assets/Icons/pin-green-13.png';
        default:
            return "";
        }
    }

};





