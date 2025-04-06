<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="SnapEat.Report" %>
<%@ Register Assembly="System.Web.DataVisualization" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .chart-container {
            width: 90%;
            max-width: 800px;
            margin: 10px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .chart-row {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 20px;
        }

        .chart-container {
            flex: 1;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #007bff;
            color: white;
        }

        @media print {
            img {
                display: block !important;
                visibility: visible !important;
            }
        }

    </style>

    <div class="chart-row">
        <div class="chart-container">
            <h2>Monthly Sales</h2>
            <asp:Chart ID="Chart1" runat="server" DataSourceID="SqlDataSource1">
                <Series>
                    <asp:Series ChartType="Line" Name="Sales" XValueMember="Month" YValueMembers="TotalSales"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea2"></asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                SelectCommand="SELECT FORMAT(dtCreated, 'yyyy-MM') AS Month, SUM(price) AS TotalSales FROM [Order] GROUP BY FORMAT(dtCreated, 'yyyy-MM') ORDER BY Month">
            </asp:SqlDataSource>
        </div>

        <div class="chart-container">
            <h2>Weekly Sales</h2>
            <asp:Chart ID="Chart2" runat="server" DataSourceID="SqlDataSource2">
                <Series>
                    <asp:Series ChartType="Line" Name="WeeklySales" XValueMember="Week" YValueMembers="TotalSales"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea4"></asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                SelectCommand="SELECT DATEPART(WEEK, dtCreated) AS Week, SUM(price) AS TotalSales FROM [Order] GROUP BY DATEPART(WEEK, dtCreated) ORDER BY Week">
            </asp:SqlDataSource>
        </div>

        <div class="chart-container">
            <h2>Daily Sales</h2>
            <asp:Chart ID="Chart3" runat="server" DataSourceID="SqlDataSource3">
                <Series>
                    <asp:Series ChartType="Line" Name="DailySales" XValueMember="Date" YValueMembers="TotalSales"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea5"></asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                SelectCommand="SELECT FORMAT(dtCreated, 'yyyy-MM-dd') AS Date, SUM(price) AS TotalSales FROM [Order] GROUP BY FORMAT(dtCreated, 'yyyy-MM-dd') ORDER BY Date">
            </asp:SqlDataSource>
        </div>
    </div>

    <div class="chart-row">
        <div class="chart-container">
            <h2>Top Selling Food Items</h2>
            <asp:Chart ID="TopFoodChart" runat="server" DataSourceID="SqlDataSourceTopFood">
                <Series>
                    <asp:Series ChartType="Bar" Name="TopFood" XValueMember="fName" YValueMembers="TotalSold"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea3"></asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
            <asp:SqlDataSource ID="SqlDataSourceTopFood" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                SelectCommand="SELECT fName, COUNT(*) AS TotalSold FROM [Order] JOIN Food ON [Order].fID = Food.fID GROUP BY fName ORDER BY TotalSold ASC">
            </asp:SqlDataSource>
        </div>

        <div class="chart-container">
            <h2>Least Selling Food Items</h2>
            <asp:Chart ID="LeastSellingChart" runat="server" DataSourceID="SqlDataSourceLeastSelling">
                <Series>
                    <asp:Series ChartType="Bar" Name="LeastSelling" XValueMember="fName" YValueMembers="TotalSold"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea5"></asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
            <asp:SqlDataSource ID="SqlDataSourceLeastSelling" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                SelectCommand="SELECT fName, COUNT(*) AS TotalSold FROM [Order] JOIN Food ON [Order].fID = Food.fID GROUP BY fName ORDER BY TotalSold DESC">
            </asp:SqlDataSource>
        </div>

    </div>

    <div style="text-align: center; margin-bottom: 20px;">
        <button onclick="printReport()">Print Report</button>
        <asp:Button ID="Button1" runat="server" Text="Cancel" PostBackUrl="~/SuperAdmin_Dashboard.aspx" />
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script>
        function printReport() {
            window.print();
            return;
        }
    </script>

</asp:Content>