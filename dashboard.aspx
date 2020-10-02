<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="suitespk.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    
    <!-- Chat app -->
    <script src="assets/js/pages/jquery.chat.js"></script>

    <!-- Todo app -->
    <script src="assets/js/pages/jquery.todo.js"></script>

    <!--Morris Chart-->
    <script src="assets/libs/morris-js/morris.min.js"></script>
    <script src="assets/libs/raphael/raphael.min.js"></script>

    <!-- Sparkline charts -->
    <script src="assets/libs/jquery-sparkline/jquery.sparkline.min.js"></script>

    <!-- Dashboard init JS -->
    <script src="assets/js/pages/dashboard.init.js"></script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">




    <!-- Begin page -->
    <div id="wrapper">


        <div class="content-page">
            <div class="content">

                <!-- Start Content-->
                <div class="container-fluid">

                    <!-- start page title -->
                    <div class="row">
                        <div class="col-12">
                            <div class="page-title-box">
                                <h4 class="page-title">Welcome To <b class="clsSpanUserName"></b></h4>
                                <div class="page-title-right">
                                    <ol class="breadcrumb p-0 m-0">
                                        <li class="breadcrumb-item active">Dashboard</li>
                                    </ol>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->

                <%--    <div class="row">
                        <div class="col-xl-3 col-sm-6">
                            <div class="card bg-pink">
                                <div class="card-body widget-style-2">
                                    <div class="text-white media">
                                        <div class="media-body align-self-center">
                                            <h2 class="my-0 text-white"><span data-plugin="counterup">50</span></h2>
                                            <p class="mb-0">Daily Visits</p>
                                        </div>
                                        <i class="ion-md-eye"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="card bg-purple">
                                <div class="card-body widget-style-2">
                                    <div class="text-white media">
                                        <div class="media-body align-self-center">
                                            <h2 class="my-0 text-white"><span data-plugin="counterup">12056</span></h2>
                                            <p class="mb-0">Sales</p>
                                        </div>
                                        <i class="ion-md-paper-plane"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="card bg-info">
                                <div class="card-body widget-style-2">
                                    <div class="text-white media">
                                        <div class="media-body align-self-center">
                                            <h2 class="my-0 text-white"><span data-plugin="counterup">1268</span></h2>
                                            <p class="mb-0">New Orders</p>
                                        </div>
                                        <i class="ion-ios-pricetag"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-xl-3 col-sm-6">
                            <div class="card bg-primary">
                                <div class="card-body widget-style-2">
                                    <div class="text-white media">
                                        <div class="media-body align-self-center">
                                            <h2 class="my-0 text-white"><span data-plugin="counterup">145</span></h2>
                                            <p class="mb-0">New Users</p>
                                        </div>
                                        <i class="mdi mdi-comment-multiple"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>--%>

                    <!-- End row -->

                
                    <!-- End row -->

                </div>
                <!-- end container-fluid -->

            </div>
            <!-- end content -->



            <!-- Footer Start -->

            <!-- end Footer -->

        </div>

        <!-- ============================================================== -->
        <!-- End Page content -->
        <!-- ============================================================== -->

    </div>
    <!-- END wrapper -->
</asp:Content>
