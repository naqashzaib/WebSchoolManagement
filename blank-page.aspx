<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="blank-page.aspx.cs" Inherits="suitespk.blank_page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div id="wrapper">
        <div class="content-page">
            <div class="content">

                <!-- Start Content-->
                <div class="container-fluid">

                    <!-- start page title -->
                    <div class="row">
                        <div class="col-12">
                            <div class="x_panel">
                                

                                </div>

                            <div class="page-title-box">
                                <h4 class="page-title">All Student Records</h4>
                                <div class="page-title-right">
                                    <ol class="breadcrumb p-0 m-0">
                                        <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
                                        <li class="breadcrumb-item"><a href="#">Add Posting</a></li>
                                        <li class="breadcrumb-item active">All Records</li>
                                    </ol>
                                </div>
                                <div class="clearfix"></div>
                            </div>
                        </div>
                    </div>
                    <!-- end page title -->
                    <hr />
                    <button type="button" class="btn btn-danger" id="btnAddstd" data-toggle="modal" data-target="#myModal">Add New Student</button>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-body table-responsive">
                                        <table id="datatable" class="table table-bordered dt-responsive nowrap" style="border-collapse: collapse; border-spacing: 0; width: 100%;">

                                            <thead>
                                            <th style="width: 6%;">Sr#</th>
                                            <th>Name</th>
                                            <th>Father Name</th>
                                            <th>Class</th>
                                            <th>Phone No.</th>
                                            <th>Edit/Delete</th>
                                            </thead>
                                            <tbody id="rowstudents">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
       
                </div>


            </div>


        </div>
    </div>
</asp:Content>
