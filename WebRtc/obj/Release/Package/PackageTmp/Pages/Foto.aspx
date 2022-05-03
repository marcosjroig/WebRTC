<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Foto.aspx.cs" Inherits="WebRtc._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <br/>

    <h2>Foto</h2>
    
    <div class="button-group">
        <button id="btn-start" type="button" class="button">Start Streaming</button>
        <button id="btn-stop" type="button" class="button">Stop Streaming</button>
        <button id="btn-capture" type="button" class="button">Capture Image</button>
    </div>

    <!-- Video Element & Canvas -->
    <div class="play-area">
        <div class="play-area-sub">
            <h3>The Stream</h3>
            <video id="stream" width="320" height="240"></video>
        </div>
        <div class="play-area-sub">
            <h3>The Capture</h3>
            <canvas id="capture" width="320" height="240"></canvas>
            <div id="snapshot"></div>
        </div>
    </div>

    <script src="../Scripts/WebRtc/adapter-latest.js"></script>
    
    <script>
        // The buttons to start & stop stream and to capture the image
        var btnStart = document.getElementById("btn-start");
        var btnStop = document.getElementById("btn-stop");
        var btnCapture = document.getElementById("btn-capture");

        // The stream & capture
        var stream = document.getElementById("stream");
        var capture = document.getElementById("capture");
        var snapshot = document.getElementById("snapshot");

        // The video stream
        var cameraStream = null;

        // Attach listeners
        btnStart.addEventListener("click", startStreaming);
        btnStop.addEventListener("click", stopStreaming);
        btnCapture.addEventListener("click", captureSnapshot);

        // Start Streaming
        function startStreaming() {

            var mediaSupport = 'mediaDevices' in navigator;

            if (mediaSupport && null == cameraStream) {

                navigator.mediaDevices.getUserMedia({ video: true })
                    .then(function (mediaStream) {

                        cameraStream = mediaStream;

                        stream.srcObject = mediaStream;

                        stream.play();
                    })
                    .catch(function (err) {

                        console.log("Unable to access camera: " + err);
                    });
            }
            else {

                alert('Your browser does not support media devices.');

                return;
            }
        }

        // Stop Streaming
        function stopStreaming() {

            if (null != cameraStream) {

                var track = cameraStream.getTracks()[0];

                track.stop();
                stream.load();

                cameraStream = null;
            }
        }

        function captureSnapshot() {

            if (null != cameraStream) {

                var ctx = capture.getContext('2d');
                var img = new Image();

                ctx.drawImage(stream, 0, 0, capture.width, capture.height);

                img.src = capture.toDataURL("image/png");
                img.width = 240;

                snapshot.innerHTML = '';

                snapshot.appendChild(img);
            }
        }

    </script>
</asp:Content>



