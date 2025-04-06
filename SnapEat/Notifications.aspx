<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="SnapEat.Notifications" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <h2><strong>Notifications</strong></h2>
    
    <div class="center-container">
        <div class="gridview-container">
            <asp:Label ID="lblNoData" runat="server" ForeColor="Red" Visible="False"></asp:Label>
            
            <asp:GridView ID="GridView1" CssClass="aspNetGrid" runat="server"
                AllowPaging="True" PageSize="10"
                AutoGenerateColumns="False" CellPadding="4" 
                DataKeyNames="nID" DataSourceID="SqlDataSource1" ForeColor="#333333" GridLines="None"
                OnRowCommand="GridView1_RowCommand"
                OnPageIndexChanging="GridView1_PageIndexChanging">
                
                <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                
                <Columns>
                    <asp:BoundField DataField="formatted_nID" HeaderText="Notification ID" ReadOnly="True" SortExpression="formatted_nID" />
                    <asp:BoundField DataField="notification" HeaderText="Notification" SortExpression="notification" />
                    
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button ID="btnDelete" runat="server" CssClass="btn btn-danger btn-sm" Text="Delete" CommandName="DeleteNotification" CommandArgument='<%# Eval("nID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
                
                <EditRowStyle BackColor="#999999" />
                <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                <SortedAscendingCellStyle BackColor="#E9E7E2" />
                <SortedAscendingHeaderStyle BackColor="#506C8C" />
                <SortedDescendingCellStyle BackColor="#FFFDF8" />
                <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
            </asp:GridView>
        </div>
    </div>

    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClientClick="history.back(); return false;"/>
    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        DeleteCommand="DELETE FROM [Notification] WHERE [nID] = @nID"
        SelectCommand="SELECT * FROM [Notification] WHERE (uID = @uID OR uID IS NULL) ORDER BY formatted_nID DESC">
        
        <DeleteParameters>
            <asp:Parameter Name="nID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:SessionParameter Name="uID" SessionField="uID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>
