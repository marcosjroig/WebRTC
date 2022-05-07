<%@ Page Title="Video Perizia" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Camara.aspx.cs" Inherits="WebRtc.Pages.Camara" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-2 col-xs-5">
            <img id="imgLogo" runat="server" style="width: 100%; height: 100%;"/>
        </div>
        <div class="col-md-10 col-xs-7">

        </div>
    </div>

    <br />

    <div>
        <asp:Button ID="btnAggiorna" runat="server" Text="Aggiorna" OnClick="btnAggiorna_OnClick" />
        <asp:Button ID="btnTermina" runat="server" Text="Termina" Style="visibility: hidden; display: none;" OnClientClick="downloadVideo(); return false;" />
    </div>

    <br />
    <div>
        <asp:Label ID="lblDescrizione" runat="server" ForeColor="red" style="font-size:80%;">
        </asp:Label>
    </div>
    <br />


    <input runat="server" id="attivaScattaFoto" name="attivaScattaFoto" style="visibility: hidden; display: none;" />

    <div>

        <div class="row">
            <div class="col-md-2 col-sm-6 col-xs-6">
                <video id="gum" playsinline autoplay muted style="border: 1px solid rgb(15, 158, 238); max-height: 355px; max-width: 300px; height: auto; width: auto;"></video>
                
                <br/>
                <asp:Label ID="lblOk" runat="server" Visible="False" style="font-size:85%;"></asp:Label>
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False" style="font-size:85%;"></asp:Label>
            </div>
            <div class="col-md-2 col-sm-6 col-xs-6" style="max-width: 310px; width: auto;">

                <asp:Label ID="lblRisoluzione" runat="server" style="font-size:75%;">
                </asp:Label>
                <select name="risoluzioneCamera" id="risoluzioneCamera" onchange="startCamara()">
                    <option value="fullHd">Full HD</option>
                    <option value="hd">HD</option>
                    <option value="media">Media</option>
                    <option value="basse">Bassa</option>
                </select><br />
                <br />

                <asp:Label ID="lblTipoCamera" runat="server" style="font-size:75%;">
                </asp:Label>
                <select name="fotoVideoOption" id="fotoVideoOption" onchange="fotoVideoSelector()">
                    <option value="foto">Foto</option>
                    <option value="video">Video</option>
                </select><br />
                <br />

                <button id="record" name="record" onclick="ScattaFotoVideo(); return false;">Scatta foto</button><br />
                <hr />

                <div id="divFotoVideoRecorded" style ="margin: 0; padding: 0;">
                    
                </div>
                
            </div>
            <div class="col-md-8">
            </div>
        </div>
        
        <canvas id="capture" width="260" height="150" style="visibility: hidden; display: none;"></canvas>
        <select id="codecPreferences" disabled style="visibility: hidden; display: none;"></select>

        <div>
            <span id="errorMsg"></span>
        </div>
        
    </div>

    <hr />
    <footer>
        <div>
            <p class="brz-css-scjbq" data-uniq-id="qegxz" data-generated-css="brz-css-qmndk"><strong style="color: rgb(32, 4, 154);">PERAUTO Informatica S.r.l.</strong></p>
            <p class="brz-css-mhpbf" data-uniq-id="rafra" data-generated-css="brz-css-plahl"><span style="color: rgb(32, 4, 154);">Via Dalmazia 37 | 72100 Brindisi</span></p>
            <p class="brz-css-sejov" data-uniq-id="kwhja" data-generated-css="brz-css-bgkll"><span style="color: rgb(32, 4, 154);">Tel. 0831 508678 Centralino</span></p>
            <p class="brz-css-yljmw" data-generated-css="brz-css-eqxml" data-uniq-id="vgqhf"><span style="color: rgb(32, 4, 154);">PIVA 01422660744&nbsp;&nbsp;</span></p>
        </div>
    </footer>

    <script src="../Scripts/WebRtc/adapter-latest.js"></script>
    <script src="../Scripts/WebRtc/HelperFunctions.js"></script>
    <script src="../Scripts/WebRtc/Video.js"></script>

</asp:Content>


