using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.Util;
using suitespk.classes;

namespace suitespk.webservices
{
    /// <summary>
    /// Summary description for AddSubjects
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AddSubjects : System.Web.Services.WebService
    {
        [WebMethod]
        public void fnAddSubject(addstudent ObjAddStd)
        {


            List<recexist> listrecexist = new List<recexist>();
            listrecexist.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(cs))
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();
                SqlTransaction transaction;
                transaction = connection.BeginTransaction("SampleTransaction");
                command.Connection = connection;
                command.Transaction = transaction;
                string exist = "";
                command.CommandText = "SELECT * FROM subjects WHERE subjects_name ='" + ObjAddStd.std_name + "'";
                SqlDataAdapter objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                DataTable dtr = new DataTable();
                objadp.Fill(dtr);
                foreach (DataRow dtrow in dtr.Rows)
                {
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                    exist = "found";
                }
                if (exist == "")
                {

                    command.CommandText = "INSERT INTO subjects (subjects_name, total_marks) VALUES ('" + ObjAddStd.std_name + "', '" + ObjAddStd.std_lastname + "')" + "SELECT SCOPE_IDENTITY()";
                    string insertedID = command.ExecuteScalar().ToString();

                   

               
                        recexist Objrecexist = new recexist();
                        Objrecexist.Dataexist = "Not Found";
                        listrecexist.Add(Objrecexist);
                }
                transaction.Commit();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listrecexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listrecexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        [WebMethod]
        public void GetSubjects()
        {
            List<addstudent> listStdInfo = new List<addstudent>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM subjects", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    addstudent StdInfo = new addstudent();
                    StdInfo.std_id = Convert.ToInt32(rdr["subjects_id"]);
                    StdInfo.std_name = rdr["subjects_name"].ToString();
                    StdInfo.std_class = rdr["total_marks"].ToString();
                    listStdInfo.Add(StdInfo);
                }
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listStdInfo).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listStdInfo));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }

    }
}
