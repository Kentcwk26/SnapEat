<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="SnapEat.ForgotPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Forgot Password</strong></h2>
    <div class="centered-form">
        <table>
            <tr>
                <td>Registered Email</td>
                <td><asp:TextBox ID="uEmail" runat="server" TextMode="Email"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Registered Name</td>
                <td><asp:TextBox ID="uName" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>New Password</td>
                <td><asp:TextBox ID="uPassword" runat="server" TextMode="Password"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Confirm Password</td>
                <td><asp:TextBox ID="confirmPassword" runat="server" TextMode="Password"></asp:TextBox></td>
            </tr>
        </table>        
    </div>
    <br/>
    <div class="button-container">
        <asp:Button ID="Button1" runat="server" Text="Change Password" OnClick="btnChangePassword_Click" CssClass="btn-danger"/>
        <asp:Button ID="btnCancel" runat="server" OnClick="BtnCancel_Click" Text="Cancel" />
    </div>
    <br />
    I don&#39;t have an account, please click <a href="Registration.aspx" CssClass="link-underline" style="text-decoration: underline">here</a> to register
</asp:Content>