<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SnapEat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            var currentIndex = 0;
            var images = $('.slideshow img');
            var imageCount = images.length;
            var fadeTime = 1000;
            var displayTime = 5000;

            function showImage(index) {
                images.stop(true, true).fadeOut(fadeTime); 
                setTimeout(() => { 
                    images.eq(index).stop(true, true).fadeIn(fadeTime);
                }, fadeTime);
            }

            function nextImage() {
                currentIndex = (currentIndex + 1) % imageCount;
                showImage(currentIndex);
            }

            images.hide();
            showImage(currentIndex);
            setInterval(nextImage, displayTime);
        });
    </script>

    <main>
        <section class="row" aria-labelledby="aspnetTitle">
            <h2><strong><asp:Label ID="Label1" runat="server" Text="Label"></asp:Label></strong></h2>
        </section>

        <div class="slideshow">
            <div class="slideshow-content">
                <a href="https://instagram.com" target="_blank">
                    <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Welcome.png" />
                </a>
            </div>
            <div class="slideshow-content">
                <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Introduction.png" />
            </div>
            <div class="slideshow-content">
               <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Menu.png" />
            </div>
            <div class="slideshow-content">
                <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Speciality.png" />
            </div>
            <div class="slideshow-content">
                <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Products.png" />
            </div>
            <div class="slideshow-content">
                <asp:Image class="photo" runat="server" ImageUrl="~/Slides/Customer_Service.png" />
            </div>
        </div>

        <div id="lnkLoginlnkRegister" runat="server" style="padding: 20px 0">
            <asp:LinkButton ID="lnkLogin" runat="server" PostBackUrl="~/Login.aspx">Login</asp:LinkButton>&nbsp;|&nbsp;<asp:LinkButton ID="lnkRegister" runat="server" PostBackUrl="~/Registration.aspx">Register</asp:LinkButton><br>
        </div>

        <asp:LinkButton ID="lnkMP" runat="server" PostBackUrl="~/ManageUProfile.aspx">Manage Profile</asp:LinkButton>
        &nbsp;<asp:Button ID="btnLogOut" runat="server" OnClick="ButtonLogOut_Click" OnClientClick="return confirm('Are you sure you want to log out?');" Text="Log Out" CssClass="btn-danger"/>

        <div class="search-container">
            <div class="search-group">
                <asp:TextBox ID="txtSearch" runat="server" BorderColor="Black" Placeholder="Search Anything ...." CssClass="search"></asp:TextBox>
                <asp:Button ID="Button2" runat="server" Text="Clear" CssClass="search-btn" OnClick="Button2_Click"/>
                <asp:Button ID="Button1" runat="server" Text="Search" CssClass="search-btn" OnClick="Button1_Click"/>
            </div>
            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropdown" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                <asp:ListItem Value="Default">All</asp:ListItem>
                <asp:ListItem Value="Food">Food</asp:ListItem>
                <asp:ListItem Value="Beverage">Beverage</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div style="padding: 20px 0;">       
            <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" RepeatColumns="5" ShowFooter="False" CssClass="list">
                <ItemTemplate>
                    <br>
                    <asp:Image ID="fImageLabel" runat="server" ImageUrl='<%# Eval("fImage") %>' style="width: 250px; height: 250px;"/>
                    <br>
                    <br>
                    <asp:Label ID="fNameLabel" runat="server" Text='<%# Eval("fName") %>' Font-Bold="true" Font-Size="20px"/>
                    <br />
                    <asp:Label ID="fPriceLabel" runat="server" Text='<%# "RM" + Eval("fPrice", "{0:0.00}") %>' />
                    <br />
                    <br>
                    <asp:Button ID="btnDetails" runat="server" Text="Details" CommandArgument='<%# Eval("fID") %>' OnClick="btnDetails_Click" />
                    <br />
                    <br>
                </ItemTemplate>
            </asp:DataList>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT * FROM [Food]"></asp:SqlDataSource>
        </div>

    </main>

</asp:Content>