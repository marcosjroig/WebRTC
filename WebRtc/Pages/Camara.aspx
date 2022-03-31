
<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Camara.aspx.cs" Inherits="WebRtc.Pages.Camara" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <br/>

   <form runat="server">
        
        <div>
            <asp:Button ID="btnAggiorna" runat="server" Text="Aggiorna" OnClick="btnAggiorna_OnClick"/>
            <asp:Button ID="btnTermina" runat="server" Text="Termina" OnClick="btnTermina_OnClick" Visible="False"/>
        </div>
        
        <br/>
        <div>
            <asp:Label ID="lblDescrizione" runat="server" ForeColor="red" Text="Sei su questa pagina perchè il mittente dell'SMS ha richiesto la documentazione fotografica.<br/>
             Utilizza il pulsante <b>Scatta</b> per effettuare le foto; per terminare, utilizza il pulsante <b>Termina</b> per inviare le foto effettuate al richiedente.">
            </asp:Label>
        </div>
        <br/>
    </form>
    

    <div>
        
        <video id="gum" playsinline autoplay muted style="border: 1px solid rgb(15, 158, 238); height: 240px; width: 320px;"></video>
        <video id="recorded" playsinline loop style="border: 1px solid rgb(15, 158, 238); height: 240px; width: 320px;"></video>

        <div>
            <button id="start" class="btn btn-success">Start camera</button>
            <button id="record" disabled class="btn btn-info">Start Recording</button>
            <button id="play" disabled class="btn btn-warning">Play</button>
            <button id="download" disabled class="btn btn-dark">Download</button>
            <button id="stop" class="btn btn-danger">Stop camera</button>
        </div>

        <div>
            Recording format:
            <select id="codecPreferences" disabled></select>
        </div>

        <div>
            <h4>Media Stream Constraints options</h4>
            <p>
                Echo cancellation:
                <input type="checkbox" id="echoCancellation">
            </p>
        </div>

        <div>
            <span id="errorMsg"></span>
        </div>

    </div>

    <script src="../Scripts/WebRtc/adapter-latest.js"></script>
    <script src="../Scripts/WebRtc/Video.js"></script>

</asp:Content>


