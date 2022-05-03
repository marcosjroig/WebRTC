/*
*  Copyright (c) 2015 The WebRTC project authors. All Rights Reserved.
*
*  Use of this source code is governed by a BSD-style license
*  that can be found in the LICENSE file in the root of the source
*  tree.
*/

// This code is adapted from
// https://rawgit.com/Miguelao/demos/master/mediarecorder.html

'use strict';


//=========================================================================
/* Variables declaration */
//=========================================================================
let mediaRecorder;
let recordedBlobs;
let fotoArray = [];
let videoArray = [];

//Declare HTML elements
const codecPreferences = document.querySelector('#codecPreferences');
const errorMsgElement = document.querySelector('span#errorMsg');

//Declare Buttons
const recordButton = document.getElementById('record');

var capture = document.getElementById("capture");
var gum = document.getElementById("gum");

var fotoCounter = 0;
var videoCounter = 0;

//=========================================================================

function ScattaFotoVideo()
{
    if (recordButton.textContent === 'Registra video') {
        recordButton.innerText = "Stop registrazione";
        startRecording();
    } else {
        if (recordButton.textContent === 'Stop registrazione') {
            stopRecording();
            recordButton.textContent = 'Registra video';
            codecPreferences.disabled = false;
        }

        if (recordButton.textContent === 'Scatta foto') {
            takeSnapshot();
        }
    }
};

function AttivaBtnTermina() {
    var btnTermina = document.getElementById("MainContent_btnTermina");
    btnTermina.style.display = "";
    btnTermina.style.visibility = "";
}

function takeSnapshot() {
    var ctx = capture.getContext('2d');
    var img = new Image();

    ctx.drawImage(gum, 0, 0, capture.width, capture.height);

    img.src = capture.toDataURL("image/png");
    img.width = 150;
    img.high = 150;

    fotoCounter = fotoCounter + 1;
    $('#divFotoRecorded').append('<span id="snapshot' + fotoCounter + '"></span>');

    var snapshot = document.getElementById('snapshot' + fotoCounter);
    snapshot.innerHTML = '';
    snapshot.appendChild(img);

    fotoArray.push(img);
    AttivaBtnTermina();
}

function SaveVideoInMemory() {
    const mimeType = codecPreferences.options[codecPreferences.selectedIndex].value.split(';', 1)[0];
    const superBuffer = new Blob(recordedBlobs, { type: mimeType });
    videoArray.push(superBuffer);

    videoCounter = videoCounter + 1;
    $('#divVideoRecorded').append('<video id="recorded' + videoCounter +'" playsinline loop style="height: 100px; width: 150px;"></video>');

    const recordedVideo = document.getElementById('recorded' + videoCounter);
    recordedVideo.src = null;
    recordedVideo.srcObject = null;
    recordedVideo.src = window.URL.createObjectURL(superBuffer);
    console.log("video source: " + recordedVideo.src);
    recordedVideo.controls = true;
};

async function downloadVideo(){

    //Save all videos
    for (let i = 0; i < videoArray.length; i++) {
        var recordedBufferBase64 = await convertBlobToBase64(videoArray[i]);
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Pages/Camara.aspx/btnTerminaOnClick",
            data: '{ "video" : "' + recordedBufferBase64 + '", "videoName" : "video' + i + '.webm"}',
            datatype: "json",
            success: function (result) {
                console.log("SUCCESS = " + result.d);
                console.log(result);
            },
            error: function (xmlhttprequest, textstatus, errorthrown) {
                console.log(" conection to the server failed ");
                console.log("error: " + errorthrown);
            }
        });
    }

    //Save all fotos
    for (let i = 0; i < fotoArray.length; i++) {
        var foto = fotoArray[i].src.replace("data:image/png;base64,", "");;
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/Pages/Camara.aspx/btnTerminaOnClick2",
            data: '{ "foto" : "' + foto + '", "fotoName" : "foto' + i + '.png"}',
            datatype: "json",
            success: function (result) {
                console.log("SUCCESS = " + result.d);
                console.log(result);
            },
            error: function (xmlhttprequest, textstatus, errorthrown) {
                console.log(" conection to the server failed ");
                console.log("error: " + errorthrown);
            }
        });
    }
};

function handleDataAvailable(event) {
    console.log('handleDataAvailable', event);
    if (event.data && event.data.size > 0) {
        recordedBlobs.push(event.data);
    }
}

function getSupportedMimeTypes() {
    const possibleTypes = [
        'video/webm;codecs=vp9,opus',
        'video/webm;codecs=vp8,opus',
        'video/webm;codecs=h264,opus',
        'video/mp4;codecs=h264,aac',
    ];
    return possibleTypes.filter(mimeType => {
        return MediaRecorder.isTypeSupported(mimeType);
    });
}

function startRecording() {
    recordedBlobs = [];
    const mimeType = codecPreferences.options[codecPreferences.selectedIndex].value;
    const options = { mimeType };

    try {
        mediaRecorder = new MediaRecorder(window.stream, options);
        AttivaBtnTermina();
    } catch (e) {
        console.error('Exception while creating MediaRecorder:', e);
        errorMsgElement.innerHTML = `Exception while creating MediaRecorder: ${JSON.stringify(e)}`;
        return;
    }

    console.log('Created MediaRecorder', mediaRecorder, 'with options', options);
    recordButton.textContent = 'Stop registrazione';
    codecPreferences.disabled = true;
    mediaRecorder.onstop = (event) => {
        console.log('Recorder stopped: ', event);
        console.log('Recorded Blobs: ', recordedBlobs);
    };
    mediaRecorder.ondataavailable = handleDataAvailable;
    mediaRecorder.start();
    console.log('MediaRecorder started', mediaRecorder);
}

function stopRecording() {
    mediaRecorder.stop();

    delay(function () {
        SaveVideoInMemory();
    }, 1000);
}

function handleSuccess(stream) {
    var attivaScattaFoto = document.getElementById("MainContent_attivaScattaFoto").value;
    
    if (attivaScattaFoto === "True") {
        recordButton.disabled = false;
    }
    else {
        recordButton.disabled = true;
    }

    //recordButton.disabled = false;
    console.log('getUserMedia() got stream:', stream);
    window.stream = stream;

    const gumVideo = document.querySelector('video#gum');
    gumVideo.srcObject = stream;

    getSupportedMimeTypes().forEach(mimeType => {
        const option = document.createElement('option');
        option.value = mimeType;
        option.innerText = option.value;
        codecPreferences.appendChild(option);
    });
    codecPreferences.disabled = false;
}

function PostBlob(blob) {
    // FormData
    var formData = new FormData();
    formData.append('video-blob', blob);
    
    // POST the Blob  
    $.ajax({
        type: 'POST',
        url: "Video/SaveRecoredFile",
        data: formData,
        cache: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result) {
                console.log('Success');
            }
        },
        error: function (result) {
            console.log(result);
        }
    });
}

async function init(constraints) {
    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints);
        handleSuccess(stream);

        risuluzione = "";
        erroreRisoluzione = false;
    } catch (e) {
        erroreRisoluzione = true;
        startCamara();
        console.error('navigator.getUserMedia error:', e);
        errorMsgElement.innerHTML = `navigator.getUserMedia error:${e.toString()}`;
    }
}

const qvgaConstraints = {
    video: { width: { exact: 320 }, height: { exact: 240 } }
};

const vgaConstraints = {
    video: { width: { exact: 640 }, height: { exact: 480 } }
};

const hdConstraints = {
    video: { width: { exact: 1280 }, height: { exact: 720 } }
};

const fullHdConstraints = {
    video: { width: { exact: 1920 }, height: { exact: 1080 } }
};

var risuluzione = "";
var erroreRisoluzione = false;

async function startCamara() {
    
    var risoluzioneCamera = document.getElementById("risoluzioneCamera");

    if (erroreRisoluzione === false) {
        switch (risoluzioneCamera.value) {
            case "fullHd":
                risuluzione = "fullHd";
                await init(hdConstraints);
                break;
            case "hd":
                risuluzione = "hd";
                await init(hdConstraints);
                break;
            case "media":
                risuluzione = "media";
                await init(vgaConstraints);
                break;
            case "basse":
                risuluzione = "basse";
                await init(qvgaConstraints);
                break;
            default:
                risuluzione = "hd";
                await init(hdConstraints);
        }
    } else {

        stopVideo();

        if (risuluzione === "fullHd") {
            risuluzione = "hd";
            erroreRisoluzione = false;
            document.getElementById("risoluzioneCamera").value = "hd";
            await init(hdConstraints);
        }
        if (risuluzione === "hd") {
            risuluzione = "media";
            erroreRisoluzione = false;
            document.getElementById("risoluzioneCamera").value = "media";
            await init(vgaConstraints);
        }
        if (risuluzione === "media") {
            risuluzione = "basse";
            erroreRisoluzione = false;
            document.getElementById("risoluzioneCamera").value = "basse";
            await init(qvgaConstraints);
        }
    }
}

async function stopVideo() {
    const video = document.querySelector('video#gum');
    const mediaStream = video.srcObject;
    await mediaStream.getTracks().forEach(track => track.stop());
    video.srcObject = null;
}

function fotoVideoSelector() {

    var fotoVideoOption = document.getElementById("fotoVideoOption").value;
    
    if (fotoVideoOption === "foto") {
        recordButton.innerText  = "Scatta foto";
    } else {
        recordButton.innerText  = "Registra video";
    }
}

startCamara();
