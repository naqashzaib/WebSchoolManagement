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
    /// Summary description for Svr_Add_Student
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Svr_Add_Student : System.Web.Services.WebService
    {
        [WebMethod]
        private string GetMD5HashData(string data)
        {
            //create new instance of md5
            MD5 md5 = MD5.Create();
            //convert the input text to array of bytes
            byte[] hashData = md5.ComputeHash(Encoding.Default.GetBytes(data));
            //create new instance of StringBuilder to save hashed data
            StringBuilder returnValue = new StringBuilder();
            //loop for each byte and add it to StringBuilder
            for (int i = 0; i < hashData.Length; i++)
            {
                returnValue.Append(hashData[i].ToString());
            }
            // return hexadecimal string
            return returnValue.ToString();
        }

        private SqlDataAdapter objadp;
        private DataTable dtr;
        //Insert student info
        [WebMethod]
        public void fnAddStd(addstudent ObjAddStd)
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
                string varPassword = GetMD5HashData(ObjAddStd.std_password);
                string exist = "";
                command.CommandText = "SELECT std_name FROM add_std_info WHERE std_name ='" + ObjAddStd.std_name + "' AND std_father ='" + ObjAddStd.std_father + "' AND classes_id ='" + ObjAddStd.std_class + "' AND std_gender ='" + ObjAddStd.std_gender + "' AND std_phone_no ='" + ObjAddStd.std_phone_no + "'";
                objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                 dtr = new DataTable();
                 objadp.Fill(dtr);
                foreach (DataRow dtrow in dtr.Rows)
                {
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                    exist = "found";
                }
                if (exist=="")
                {
                   
                    command.CommandText = "INSERT INTO add_std_info (std_name, std_lastname,std_father,std_gender, classes_id, std_phone_no) VALUES ('" + ObjAddStd.std_name + "', '" + ObjAddStd.std_lastname + "','" + ObjAddStd.std_father + "', '" + ObjAddStd.std_gender + "', '" + ObjAddStd.std_class + "', '" + ObjAddStd.std_phone_no + "')" + "SELECT SCOPE_IDENTITY()";
                    string insertedID = command.ExecuteScalar().ToString();

                    command.CommandText = "SELECT login_email FROM login WHERE login_email ='" + ObjAddStd.std_email + "' ";
                    objadp = new SqlDataAdapter(command.CommandText, connection);
                    objadp.SelectCommand.Transaction = transaction;
                    dtr = new DataTable();
                    objadp.Fill(dtr);
                    foreach (DataRow dtrow in dtr.Rows)
                    {
                        recexist Objrecexist = new recexist();
                        Objrecexist.Dataexist = "found_email";
                        listrecexist.Add(Objrecexist);
                        exist = "found_email";
                    }


                    if (exist=="")
                    {
                        command.CommandText = "INSERT INTO login (login_email, login_password,login_name,login_type,member_id) VALUES ( '" + ObjAddStd.std_email + "', '" + varPassword + "','" + ObjAddStd.std_name + "','student','"+ insertedID + "')";
                        command.ExecuteNonQuery();

                        recexist Objrecexist = new recexist();
                        Objrecexist.Dataexist = "Not Found";
                        listrecexist.Add(Objrecexist);
                    }
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

        //Fetching student info in table data
        [WebMethod]
        public void GetstdInfo()
        {
            List<addstudent> listStdInfo = new List<addstudent>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM add_std_info,classes,login where login.member_id=add_std_info.std_id AND  classes.classes_id=add_std_info.classes_id", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    addstudent StdInfo = new addstudent();
                    StdInfo.std_id = Convert.ToInt32(rdr["std_id"]);
                    StdInfo.std_name = rdr["std_name"].ToString();
                    StdInfo.std_father = rdr["std_father"].ToString();
                    StdInfo.std_class = rdr["classes_name"].ToString();
                    StdInfo.std_phone_no = rdr["std_phone_no"].ToString();
                    StdInfo.classes_id = rdr["classes_id"].ToString();
                    StdInfo.std_gender = rdr["std_gender"].ToString();
                    StdInfo.std_lastname = rdr["std_lastname"].ToString();
                    StdInfo.std_email = rdr["login_email"].ToString();
                    StdInfo.std_password = rdr["login_password"].ToString();
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

        //Fetching student info in Pop-up
        //Update student info
        [WebMethod]
        public void EditStdInfo(addstudent ObjEditStdInfo)
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
                string varPassword = GetMD5HashData(ObjEditStdInfo.std_password);
                command.CommandText = "UPDATE add_std_info SET std_name ='" + ObjEditStdInfo.std_name + "',std_lastname ='" + ObjEditStdInfo.std_lastname + "', std_father ='" + ObjEditStdInfo.std_father + "',std_gender ='" + ObjEditStdInfo.std_gender + "', classes_id ='" + ObjEditStdInfo.std_class + "', std_phone_no ='" + ObjEditStdInfo.std_phone_no + "' WHERE std_id= '" + ObjEditStdInfo.std_id + "'";
                command.ExecuteNonQuery();
                command.CommandText = "UPDATE login SET login_name ='" + ObjEditStdInfo.std_name + "',login_email ='" + ObjEditStdInfo.std_email + "',login_password ='" + varPassword + "' WHERE member_id= '" + ObjEditStdInfo.std_id + "'";
                command.ExecuteNonQuery();
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
        //Delete record
        [WebMethod]
        public void DelStdInfo(addstudent ObjDelStdInfo)
        {
            string connectionCS = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objconn = new SqlConnection(connectionCS))
            {
                objconn.Open();
                SqlCommand cmd3 = new SqlCommand("DELETE FROM add_std_info WHERE std_id = '" + ObjDelStdInfo.std_id + "'", objconn);
                cmd3.ExecuteNonQuery();
                objconn.Close();
                objconn.Open();
                SqlCommand cmd4 = new SqlCommand("DELETE FROM login WHERE member_id = '" + ObjDelStdInfo.std_id + "'", objconn);
                cmd4.ExecuteNonQuery();
                objconn.Close();
            }
        }

        [WebMethod]
        public void Addclasses(addstudent ObjAddStd)
        {
            List<recexist> listrecexist = new List<recexist>();
            listrecexist.Clear();
            string ConnectionString = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objcon = new SqlConnection(ConnectionString))
            {
                objcon.Open();
                SqlCommand cmd3 = new SqlCommand("SELECT classes_name FROM classes WHERE classes_name ='" + ObjAddStd.std_name + "'", objcon);
                SqlDataReader re = null;
                re = cmd3.ExecuteReader();
                if (re.HasRows)
                {
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                }
                else
                {
                    objcon.Close();
                    objcon.Open();
                    SqlCommand cmnd2 = new SqlCommand("INSERT INTO classes (classes_name) VALUES ('" + ObjAddStd.std_name + "')", objcon);
                    cmnd2.ExecuteNonQuery();
                    objcon.Close();
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "Not Found";
                    listrecexist.Add(Objrecexist);
                }
                objcon.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listrecexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listrecexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        //Fetching student info in table data
        [WebMethod]
        public void Getclasses()
        {
            List<addstudent> listStdInfo = new List<addstudent>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM classes", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    addstudent StdInfo = new addstudent();
                    StdInfo.std_id = Convert.ToInt32(rdr["classes_id"]);
                    StdInfo.std_name = rdr["classes_name"].ToString();
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
        //Fetching student info in Pop-up
        //Update student info
        [WebMethod]
        public void UpdateClasses(addstudent ObjEditStdInfo)
        {
            List<recexist> listrecexist = new List<recexist>();
            listrecexist.Clear();
            string ConnectionString = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objcon = new SqlConnection(ConnectionString))
            {
                objcon.Open();
                SqlCommand cmd3 = new SqlCommand("SELECT classes_name FROM classes WHERE classes_name ='" + ObjEditStdInfo.std_name + "'", objcon);
                SqlDataReader re = null;
                re = cmd3.ExecuteReader();
                if (re.HasRows)
                {
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "found";
                    listrecexist.Add(Objrecexist);
                }
                else
                {
                    objcon.Close();
                    objcon.Open();
                    SqlCommand cmnd2 = new SqlCommand("UPDATE classes SET classes_name ='" + ObjEditStdInfo.std_name + "' WHERE classes_id= '" + ObjEditStdInfo.std_id + "'", objcon);
                    cmnd2.ExecuteNonQuery();
                    objcon.Close();
                    recexist Objrecexist = new recexist();
                    Objrecexist.Dataexist = "Not Found";
                    listrecexist.Add(Objrecexist);
                }
                objcon.Close();
            }
            JavaScriptSerializer js = new JavaScriptSerializer();
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.AddHeader("content-length", js.Serialize(listrecexist).Length.ToString());
            Context.Response.Flush();
            Context.Response.Write(js.Serialize(listrecexist));
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        //Delete record
        [WebMethod]
        public void DelClasses(addstudent ObjDelStdInfo)
        {
            string connectionCS = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objconn = new SqlConnection(connectionCS))
            {
                objconn.Open();
                SqlCommand cmd3 = new SqlCommand("DELETE FROM classes WHERE classes_id = '" + ObjDelStdInfo.std_id + "'", objconn);
                cmd3.ExecuteNonQuery();
                objconn.Close();
            }
        }

        //Insert Teacher
        [WebMethod]
        public void fnAddTecher(addstudent ObjAddStd)
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
                string varPassword = GetMD5HashData(ObjAddStd.std_password);
                string exist = "";
                command.CommandText = "SELECT t_name FROM  addteacher WHERE  t_name ='" + ObjAddStd.std_name + "' AND t_lastname ='" + ObjAddStd.std_name + "' AND t_father ='" + ObjAddStd.std_father + "'  AND t_gender ='" + ObjAddStd.std_gender + "' AND t_phone_no ='" + ObjAddStd.std_phone_no + "'";
                objadp = new SqlDataAdapter(command.CommandText, connection);
                objadp.SelectCommand.Transaction = transaction;
                dtr = new DataTable();
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

                    command.CommandText = "INSERT INTO addteacher (t_name, t_lastname,t_father,t_gender, t_phone_no) VALUES ('" + ObjAddStd.std_name + "', '" + ObjAddStd.std_lastname + "','" + ObjAddStd.std_father + "', '" + ObjAddStd.std_gender + "', '" + ObjAddStd.std_phone_no + "')" + "SELECT SCOPE_IDENTITY()";
                    string insertedID = command.ExecuteScalar().ToString();

                    command.CommandText = "SELECT login_email FROM login WHERE login_email ='" + ObjAddStd.std_email + "' ";
                    objadp = new SqlDataAdapter(command.CommandText, connection);
                    objadp.SelectCommand.Transaction = transaction;
                    dtr = new DataTable();
                    objadp.Fill(dtr);
                    foreach (DataRow dtrow in dtr.Rows)
                    {
                        recexist Objrecexist = new recexist();
                        Objrecexist.Dataexist = "found_email";
                        listrecexist.Add(Objrecexist);
                        exist = "found_email";
                    }


                    if (exist == "")
                    {
                        command.CommandText = "INSERT INTO login (login_email, login_password,login_name,login_type,member_id) VALUES ( '" + ObjAddStd.std_email + "', '" + varPassword + "','" + ObjAddStd.std_name + "','teacher','" + insertedID + "')";
                        command.ExecuteNonQuery();

                        recexist Objrecexist = new recexist();
                        Objrecexist.Dataexist = "Not Found";
                        listrecexist.Add(Objrecexist);
                    }
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

        //Fetching student info in table data
        [WebMethod]
        public void GetTecherInfo()
        {
            List<addstudent> listStdInfo = new List<addstudent>();
            listStdInfo.Clear();
            string cs = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM addteacher ,login where login.member_id=addteacher.t_id  ", con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    addstudent StdInfo = new addstudent();
                    StdInfo.std_id = Convert.ToInt32(rdr["t_id"]);
                    StdInfo.std_name = rdr["t_name"].ToString();
                    StdInfo.std_father = rdr["t_father"].ToString();
                    StdInfo.std_phone_no = rdr["t_phone_no"].ToString();
                    StdInfo.std_gender = rdr["t_gender"].ToString();
                    StdInfo.std_lastname = rdr["t_lastname"].ToString();
                    StdInfo.std_email = rdr["login_email"].ToString();
                    StdInfo.std_password = rdr["login_password"].ToString();
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

        //Fetching student info in Pop-up
        //Update student info
        [WebMethod]
        public void EditTecherInfo(addstudent ObjEditStdInfo)
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
                string varPassword = GetMD5HashData(ObjEditStdInfo.std_password);
                command.CommandText = "UPDATE addteacher SET t_name ='" + ObjEditStdInfo.std_name + "',t_lastname ='" + ObjEditStdInfo.std_lastname + "', t_father ='" + ObjEditStdInfo.std_father + "',t_gender ='" + ObjEditStdInfo.std_gender + "', t_phone_no ='" + ObjEditStdInfo.std_phone_no + "' WHERE t_id= '" + ObjEditStdInfo.std_id + "'";
                command.ExecuteNonQuery();
                command.CommandText = "UPDATE login SET login_name ='" + ObjEditStdInfo.std_name + "',login_email ='" + ObjEditStdInfo.std_email + "',login_password ='" + varPassword + "' WHERE member_id= '" + ObjEditStdInfo.std_id + "'";
                command.ExecuteNonQuery();
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
        //Delete record
        [WebMethod]
        public void DelTecherInfo(addstudent ObjDelStdInfo)
        {
            string connectionCS = ConfigurationManager.ConnectionStrings["student_data"].ConnectionString;
            using (SqlConnection objconn = new SqlConnection(connectionCS))
            {
                objconn.Open();
                SqlCommand cmd3 = new SqlCommand("DELETE FROM addteacher WHERE t_id = '" + ObjDelStdInfo.std_id + "'", objconn);
                cmd3.ExecuteNonQuery();
                objconn.Close();
                objconn.Open();
                SqlCommand cmd4 = new SqlCommand("DELETE FROM login WHERE member_id = '" + ObjDelStdInfo.std_id + "'", objconn);
                cmd4.ExecuteNonQuery();
                objconn.Close();
            }
        }

    }
}
