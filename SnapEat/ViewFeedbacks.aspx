<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewFeedbacks.aspx.cs" Inherits="SnapEat.ViewFeedbacks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>View Feedbacks</strong></h2>
    <div class="center-container">

        <asp:DataList ID="DataList1" runat="server" DataKeyField="rID" DataSourceID="SqlDataSource1" RepeatColumns="4" CellPadding="3" BackColor="White" BorderColor="White" BorderStyle="Ridge" BorderWidth="2px" CellSpacing="1">
            <FooterStyle BackColor="#C6C3C6" ForeColor="Black" />
            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#E7E7FF" />
            <ItemStyle BackColor="#DEDFDE" ForeColor="Black" />
            <ItemTemplate>
                <br />
                ID:
                <asp:Label ID="formatted_rIDLabel" runat="server" Text='<%# Eval("formatted_rID") %>' />
                <br />
                <br />
                <asp:Label ID="feedbackLabel" runat="server" Text='<%# Eval("feedback") %>' />
                <br />
                <br />
            </ItemTemplate>
            <SelectedItemStyle BackColor="#9471DE" Font-Bold="True" ForeColor="White" />
        </asp:DataList>

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