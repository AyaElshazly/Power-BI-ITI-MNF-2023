using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace ExaminationSystem
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
            getcourse();
            gettype();
        }
        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        public string username = "";
        public int examid = 151045;
        public int studentid = 600;
        public string coursename = "";
        private void getcourse()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct cr_name from Course order by cr_name", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("cr_name", typeof(string));
            dt.Load(rdr);
            course.ValueMember = "cr_name";
            course.DataSource = dt;
            con.Close();
        }
        private void gettype()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct usertype from Registeration", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("usertype", typeof(string));
            dt.Load(rdr);
            type.ValueMember = "usertype";
            type.DataSource = dt;
            con.Close();
        }
        private void label10_Click(object sender, EventArgs e)
        {

        }

        private void label12_Click(object sender, EventArgs e)
        {

        }

        private void comboBox5_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void log_Click(object sender, EventArgs e)
        {
            if (user.Text == "" || pass.Text == "" || course.Text == "" || type.Text == "")
            {
                MessageBox.Show("Missing Information");
            }
            else
            {
                con.Open();
                SqlDataAdapter sda = new SqlDataAdapter("select count(*) from Registeration where (username='" + user.Text + "' or email='" + user.Text + "') and password='" + pass.Text + "'", con);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                SqlDataAdapter sdtype = new SqlDataAdapter("select usertype from Registeration where (username='" + user.Text + "' or email='" + user.Text + "') and password='" + pass.Text + "'", con);
                DataTable dttype = new DataTable();
                sdtype.Fill(dttype);
                if (dt.Rows[0][0].ToString() == "1")
                {
                    if (type.Text == "Student" && dttype.Rows[0][0].ToString() == "Student")
                    {
                        SqlDataAdapter sda1 = new SqlDataAdapter("select max(exam_id) from Exam where cr_id =(select cr_id from Course where cr_name='" + course.Text.ToString() + "')", con);
                        DataTable dt1 = new DataTable();
                        sda1.Fill(dt1);
                        examid = Convert.ToInt32(dt1.Rows[0][0].ToString());

                        SqlDataAdapter sda2 = new SqlDataAdapter("SELECT Register_Student.st_id FROM Register_Student INNER JOIN Registeration ON Register_Student.register_id = Registeration.register_id WHERE Registeration.username ='" + user.Text + "' or Registeration.email='" + user.Text + "'", con);
                        DataTable dt2 = new DataTable();
                        sda2.Fill(dt2);
                        studentid = Convert.ToInt32(dt2.Rows[0][0].ToString());

                        coursename = course.Text.ToString();
                        username = user.Text;
                        //MessageBox.Show(examid.ToString()+studentid.ToString());
                        StudentExam obj = new StudentExam(examid, studentid, coursename);
                        obj.Show();
                        this.Hide();
                        con.Close();
                    }
                    else if (type.Text == "Instructor" && dttype.Rows[0][0].ToString() == "Instructor")
                    {
                        GenerateExam obj = new GenerateExam();
                        obj.Show();
                        this.Hide();
                        con.Close();
                    }
                    else
                    {
                        MessageBox.Show("Wrong Type");
                    }
                }
                else
                {
                    MessageBox.Show("Wrong UserName or Email Or Password");
                }
                con.Close();
            }
        }

        private void panel6_Paint(object sender, PaintEventArgs e)
        {

        }
    }
}