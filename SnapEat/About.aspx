<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="SnapEat.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <link href="style.css" rel="stylesheet" type="text/css"/>

    <div class="video-container">
        <video width="100%" height="50%" controls autoplay muted loop>
            <source src="test.mp4" type="video/mp4">
            Your browser does not support the video tag.
        </video>
    </div>

    <section class="about">
        <h2>Who We Are</h2>
        <p style="text-align: center; margin: 0 auto;">SnapEat is an online food ordering platform that brings your favorite meals to your doorstep, fast and hassle-free.
        The name “SnapEat” combines Snap (speed and ease) and Eat (delicious food), reflecting our mission to simplify food ordering.</p>
    </section>

    <section class="mission">
        <h2>Our Mission</h2>
        <ul>
            <li>🚀 Fast & Reliable Delivery – Enjoy hot, fresh meals delivered in no time</li>
            <li>🍽️ Endless Choices – Explore 1,000+ dishes from local and international cuisines</li>
            <li>📱 Easy Ordering – A seamless, user-friendly platform for smooth transactions</li>
            <li>💳 Secure & Multiple Payment Options – Choose from e-wallets, credit cards, and more</li>
        </ul>
    </section>

    <section class="why-choose-us">
        <h2>Why Choose SnapEat?</h2>
        <div class="features">
            <div class="feature">
                <img src="fast.jpg" alt="Fast Delivery">
                <h6>🚀 Lightning-Fast Delivery</h6>
                <p>We ensure your food arrives fresh and on time.</p>
            </div>
            <div class="feature">
                <img src="variety.jpg" alt="Wide Selection">
                <h6>🍽️ A Wide Selection</h6>
                <p>Discover 100+ cuisines from local favorites to international delights.</p>
            </div>
            <div class="feature">
                <img src="secure.jpg" alt="Secure Payment">
                <h6>💳 Secure Payments</h6>
                <p>Enjoy cashless transactions with trusted payment gateways.</p>
            </div>
            <div class="feature">
                <img src="support.jpg" alt="Customer Support">
                <h6>📞 24/7 Customer Support</h6>
                <p>Our support team is always ready to assist you.</p>
            </div>
        </div>
    </section>

    <section class="vision">
        <h2>Our Vision</h2>
        <p style="text-align: center; margin: 0 auto;">We aim to make online food ordering a stress-free, enjoyable experience for everyone.
        Our vision is to be Malaysia’s leading food delivery platform, providing fresh, tasty, and affordable meals at your convenience.</p>
    </section>

</asp:Content>
