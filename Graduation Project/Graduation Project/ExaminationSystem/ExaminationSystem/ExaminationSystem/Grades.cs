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
    public partial class Grades : Form
    {
        public Grades()
        {
            InitializeComponent();
            getexam();
            getfname();
            getlname();
        }
        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        private void getexam()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct exam_id from Exam order by exam_id desc", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("exam_id", typeof(string));
            dt.Load(rdr);
            exam_id.ValueMember = "exam_id";
            exam_id.DataSource = dt;
            con.Close();
        }
        private void getfname()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct st_fname from Student order by st_fname", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("st_fname", typeof(string));
            dt.Load(rdr);
            st_fname.ValueMember = "st_fname";
            st_fname.DataSource = dt;
            con.Close();
        }
        private void getlname()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct st_lname from Student order by st_lname", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("st_lname", typeof(string));
            dt.Load(rdr);
            st_lname.ValueMember = "st_lname";
            st_lname.DataSource = dt;
            con.Close();
        }
        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void gunaDataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            if(exam_id.Text==""|| st_fname.Text == "" && st_lname.Text == "")
            {
                MessageBox.Show("Missing Information");
            }
            else
            {
                try
                {
                    con.Open();
                    string query = "SELECT Student.st_id,concat(Student.st_fname,' ', Student.st_lname)as Name, Student_Course.grade as Grade FROM Exam INNER JOIN Student_Course ON Exam.cr_id = Student_Course.cr_id INNER JOIN Student_Exam ON Exam.exam_id = Student_Exam.ex_id INNER JOIN Student ON Student_Course.st_id = Student.st_id AND Student_Exam.st_id = Student.st_id where exam_id=" + exam_id.Text + " and Student.st_fname='" + st_fname.Text + "' and Student.st_lname='" + st_lname.Text + "'";
                    SqlDataAdapter sda = new SqlDataAdapter(query, con);
                    SqlCommandBuilder builder = new SqlCommandBuilder(sda);
                    var ds = new DataSet();
                    sda.Fill(ds);
                    allGrades.DataSource = ds.Tables[0];
                    con.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void st_name_TextChanged(object sender, EventArgs e)
        {

        }

        private void int_id_TextChanged(object sender, EventArgs e)
        {

        }

        private void panel6_Paint(object sender, PaintEventArgs e)
        {

        }

        private void all_Click(object sender, EventArgs e)
        {
            if (exam_id.Text == "")
            {
                MessageBox.Show("Missing Information");
            }
            else
            {
                try
                {
                    con.Open();
                    string query = "SELECT distinct (Student.st_id),concat(Student.st_fname,' ', Student.st_lname)as Name, Student_Course.grade as Grade FROM Exam INNER JOIN Student_Course ON Exam.cr_id = Student_Course.cr_id INNER JOIN Student_Exam ON Exam.exam_id = Student_Exam.ex_id INNER JOIN Student ON Student_Course.st_id = Student.st_id AND Student_Exam.st_id = Student.st_id where exam_id=" + exam_id.Text + " and int_id=(select MAX(int_id) from Intake)";
                    SqlDataAdapter sda = new SqlDataAdapter(query, con);
                    SqlCommandBuilder builder = new SqlCommandBuilder(sda);
                    var ds = new DataSet();
                    sda.Fill(ds);
                    allGrades.DataSource = ds.Tables[0];
                    con.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }

        }

        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void label10_Click(object sender, EventArgs e)
        {
            Exam obj = new Exam();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void label11_Click(object sender, EventArgs e)
        {
            GenerateExam obj = new GenerateExam();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void gunaCirclePictureBox5_Click(object sender, EventArgs e)
        {
            Login obj = new Login();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void gunaCirclePictureBox1_Click(object sender, EventArgs e)
        {

        }
    }
}
