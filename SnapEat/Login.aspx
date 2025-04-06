<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SnapEat.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Login</strong></h2>
    <div class="centered-form">
        <table>
            <tr>
                <td>Email</td>
                <td><asp:TextBox ID="uEmail" runat="server" TextMode="Email"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Password</td>
                <td><asp:TextBox ID="uPassword" runat="server" TextMode="Password"></asp:TextBox></td>
            </tr>
        </table>        
    </div>
    <br/>
    <asp:Button ID="Button1" runat="server" Text="Login" OnClick="Button1_Click" />&nbsp;<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/ForgotPassword.aspx" CssClass="link-underline">Forgot Password</asp:HyperLink><br />
    <br />
    I don&#39;t have an account, please click <a href="Registration.aspx" CssClass="link-underline" style="text-decoration: underline">here</a> to register
</asp:Content>