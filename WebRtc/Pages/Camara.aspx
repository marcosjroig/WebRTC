<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Camara.aspx.cs" Inherits="WebRtc._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <br/>

    <h2>Camara</h2>
    
    <div>

        <video id="gum-local" autoplay playsinline></video>
        <button id="showVideo">Open camera</button>

        <div id="errorMsg"></div>

        <p class="warning"><strong>Warning:</strong> if you're not using headphones, pressing play will cause feedback.</p>

        <p>Display the video stream from <code>getUserMedia()</code> in a video element.</p>

        <p>The <code>MediaStream</code> object <code>stream</code> passed to the <code>getUserMedia()</code> callback is in
            global scope, so you can inspect it from the console.</p>

    </div>
    
    <script>
        // Put variables in global scope to make them available to the browser console.
        const constraints = window.constraints = {
            audio: false,
            video: true
        };

        function handleSuccess(stream) {
            const video = document.querySelector('video');
            const videoTracks = stream.getVideoTracks();
            console.log('Got stream with constraints:', constraints);
            console.log(`Using video device: ${videoTracks[0].label}`);
            window.stream = stream; // make variable available to browser console
            video.srcObject = stream;
        }

        function handleError(error) {
            if (error.name === 'OverconstrainedError') {
                const v = constraints.video;
                errorMsg(`The resolution ${v.width.exact}x${v.height.exact} px is not supported by your device.`);
            } else if (error.name === 'NotAllowedError') {
                errorMsg('Permissions have not been granted to use your camera and ' +
                    'microphone, you need to allow the page access to your devices in ' +
                    'order for the demo to work.');
            }
            errorMsg(`getUserMedia error: ${error.name}`, error);
        }

        function errorMsg(msg, error) {
            const errorElement = document.querySelector('#errorMsg');
            errorElement.innerHTML += `<p>${msg}</p>`;
            if (typeof error !== 'undefined') {
                console.error(error);
            }
        }

        async function init(e) {
            console.log("hello");
            try {
                const stream = await navigator.mediaDevices.getUserMedia(constraints);
                handleSuccess(stream);
                e.target.disabled = true;
            } catch (e) {
                alert(e);
                handleError(e);
            }
        }

        document.querySelector('#showVideo').addEventListener('click', e => init(e));
    </script>

    <script src="../Scripts/WebRtc/adapter-latest.js"></script>
    <script src="../Scripts/WebRtc/ga.js"></script>
    <%--<script src="../Scripts/WebRtc/main.js"></script>--%>

</asp:Content>


