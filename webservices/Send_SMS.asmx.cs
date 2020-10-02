using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using suitespk.classes;
using System.Data;

namespace suitespk.webservices
{
    /// <summary>
    /// Summary description for Send_SMS
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Send_SMS : System.Web.Services.WebService
    {
        public SqlDataAdapter objadp;
        public DataTable datatable;
        public class GetClasses
        {
            public string classes_id { get; set; }
            public string classes_name { get; set; }
        }
        public class GetStudentName
        {
            public string classes_id { get; set; }
            public string std_id { get; set; }
            public string std_name { get; set; }
            public string std_father { get; set; }
            public string std_phone_no { get; set; }
        }

        public class ClsTableData
        {
            public List<GetClasses> GetClasses = new List<GetClasses>();

            public List<GetStudentName> GetStudentName = new List<GetStudentName>();
        }
        [WebMethod(EnableSession = true)]
        public void GetRecord()
        {
            ClsTableData objtabeldata = new ClsTableData();
         
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(cs))
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;
                transaction = connection.BeginTransaction("SampleTransaction");
                command.Connection = connection;
                command.Transaction = transaction;

                List<GetClasses> listclspetticash = new List<GetClasses>();
                listclspetticash.Clear();
                command.CommandText = "select * from classes";
                objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                datatable = new DataTable();
                objadp.Fill(datatable);
                foreach (DataRow rdr in datatable.Rows)
                {
                    GetClasses getGetClasses = new GetClasses();
                    getGetClasses.classes_id = rdr["classes_id"].ToString();
                    getGetClasses.classes_name = rdr["classes_name"].ToString();
                    listclspetticash.Add(getGetClasses);
                }
                objtabeldata.GetClasses = listclspetticash;
                List<GetStudentName> listGetStudentName = new List<GetStudentName>();
                listGetStudentName.Clear();
                command.CommandText = "select * from add_std_info";
                objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                datatable = new DataTable();
                objadp.Fill(datatable);
                foreach (DataRow rdr in datatable.Rows)
                {
                    GetStudentName getGetClasses = new GetStudentName();
                    getGetClasses.std_id = rdr["std_id"].ToString();
                    getGetClasses.std_name = rdr["std_name"].ToString();
                    getGetClasses.std_father = rdr["std_father"].ToString();
                    getGetClasses.std_phone_no = rdr["std_phone_no"].ToString();
                    getGetClasses.classes_id = rdr["classes_id"].ToString();
                    listGetStudentName.Add(getGetClasses);
                }
                objtabeldata.GetStudentName = listGetStudentName;
                transaction.Commit();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(objtabeldata).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(objtabeldata));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
    }
}
