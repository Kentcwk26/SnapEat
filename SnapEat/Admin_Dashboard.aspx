<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin_Dashboard.aspx.cs" Inherits="SnapEat.Admin_Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <section class="row" aria-labelledby="aspnetTitle">
            <h2><strong><asp:Label ID="Label1" runat="server" Text="Label"></asp:Label></strong></h2>
        </section>
        <div class="centered-table">
            <table>
                <tr>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton5" runat="server" PostBackUrl="~/Default.aspx" 
                            Height="250" Width="250" ImageUrl="~/Logo.png" />
                        <br>
                        <a href="Default.aspx">SnapEats Website</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton1" runat="server" PostBackUrl="~/SA_Registration.aspx" 
                            Height="250" Width="250" ImageUrl="~/SA_registration.jpg" />
                        <br>
                        <a href="SA_Registration.aspx">Staff / Admin Registration</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton2" runat="server" PostBackUrl="~/ViewInformation.aspx" 
                            Height="250" Width="250" ImageUrl="~/ViewCustomer.jpg"/>
                        <br>
                        <a href="ViewInformation.aspx">User Information</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton3" runat="server" PostBackUrl="~/ManageFProfile.aspx" 
                            Height="250" Width="250" ImageUrl="~/ManageFood.jpg"/>
                        <br>
                        <a href="Food.aspx">Manage Food</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton4" runat="server" PostBackUrl="~/Report.aspx" ImageUrl="~/Report.jpg" 
                            Height="250" Width="250" />
                        <br>
                        <a href="Report.aspx">Generate Report</a>
                    </td>
                </tr>
                <tr>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton6" runat="server" PostBackUrl="~/ManageOrders.aspx" 
                            Height="250" Width="250" ImageUrl="~/ManageOrders.jpg" />
                        <br>
                        <a href="ManageOrders.aspx">Manage Orders</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton7" runat="server" PostBackUrl="~/ManageNotifications.aspx"
                            Height="250" Width="250" ImageUrl="~/Notifications.jpg" />
                        <br>
                        <a href="ManageNotifications.aspx">Manage Notifications</a>
                    </td>
                    <td style="border: none; text-align: center; padding: 6px;">
                        <asp:ImageButton ID="ImageButton8" runat="server" PostBackUrl="~/ViewFeedbacks.aspx"
                            Height="250" Width="250" ImageUrl="~/Feedbacks.jpg" />
                        <br>
                        <a href="ViewFeedbacks.aspx">View Feedbacks</a>
                    </td>
                </tr>
            </table>
        </div>
        <div id="lnkLoginlnkRegister" runat="server" style="padding: 20px 0">
            <asp:LinkButton ID="lnkLogin" runat="server" PostBackUrl="~/Login.aspx">Login</asp:LinkButton>&nbsp;|&nbsp;<asp:LinkButton ID="lnkRegister" runat="server" PostBackUrl="~/Registration.aspx">Register</asp:LinkButton><br>
        </div>
        <div style="margin-top: 40px">
            <asp:LinkButton ID="lnkMP" runat="server" PostBackUrl="~/ManageUProfile.aspx">Manage Profile</asp:LinkButton>
            &nbsp;<asp:Button ID="btnLogOut" runat="server" OnClick="ButtonLogOut_Click" OnClientClick="return confirm('Are you sure you want to log out?');" Text="Log Out" CssClass="btn-danger"/>
        </div>
    </main>
</asp:Content>