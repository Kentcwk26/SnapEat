<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="SnapEat.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link href="style.css" rel="stylesheet" type="text/css"/>

    <section class="contact-card">
        <h2>📞 Get in Touch with Us</h2>
        <p>Have a question, feedback, or need assistance?<br>We’re here to help!</p>

        <div class="contact-info">
            <div class="info-item">
                <h6>📧 For any collabrations, please drop us an email</h6>
                <p><a href="mailto:snapeat@gmail.com" style="color: blue; text-decoration: underline">snapeat@gmail.com</a></p>
            </div>
        </div>
    </section>

    <div class="centered-table">
        <table style="margin: 0 auto;">
            <tr>
                <td style="border: none;">
                    <asp:TextBox ID="txtMessage" runat="server" CssClass="input-field" TextMode="MultiLine" placeholder="Drop your question, feedback or need assistance here ...."></asp:TextBox>
                </td>
            </tr>
        </table>

        <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="btn-submit" style="margin: 10px 0;" OnClick="btnSubmit_Click"/>
    </div>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" DeleteCommand="DELETE FROM [Feedback] WHERE [rID] = @rID" InsertCommand="INSERT INTO [Feedback] ([uID], [feedback], [formatted_rID]) VALUES (@uID, @feedback, @formatted_rID)" SelectCommand="SELECT * FROM [Feedback]" UpdateCommand="UPDATE [Feedback] SET [uID] = @uID, [feedback] = @feedback, [formatted_rID] = @formatted_rID WHERE [rID] = @rID">
        <DeleteParameters>
            <asp:Parameter Name="rID" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="uID" Type="String" />
            <asp:Parameter Name="feedback" Type="String" />
            <asp:Parameter Name="formatted_rID" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="uID" Type="String" />
            <asp:Parameter Name="feedback" Type="String" />
            <asp:Parameter Name="formatted_rID" Type="String" />
            <asp:Parameter Name="rID" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

</asp:Content>