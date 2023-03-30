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
    public partial class Rating : Form
    {
        public Rating(int exid, int sid, string sgrade)
        {
            InitializeComponent();
            fun(exid, sid, sgrade);
        }
        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        public string grade = "";
        public int examid = 1;
        public int stid = 1;
        public void fun(int exid, int sid, string sgrade)
        {
            grade = sgrade;
            examid = exid;
            stid = sid;
        }
        private void Rating_Load(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void log_Click(object sender, EventArgs e)
        {
            if (course.Text == "" || instructor.Text == "")
            {
                MessageBox.Show("Missing Information");
            }
            else
            {
                if ((Convert.ToInt32(course.Text) <= 10) && (Convert.ToInt32(course.Text) > 0) && (Convert.ToInt32(instructor.Text) <= 10) && (Convert.ToInt32(instructor.Text) > 0))
                {
                    con.Open();
                    string query = "update Student_Course set cr_rate=" + course.Text + " ,ins_rate=" + instructor.Text + " where st_id=" + stid.ToString() + " and cr_id=(select top 1 cr_id from Exam where exam_id=" + examid.ToString() + ")";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.ExecuteNonQuery();

                    SqlDataAdapter sda = new SqlDataAdapter("select grade from Student_Course where st_id=" + stid.ToString() + " and cr_id=(select top 1 cr_id from Exam where exam_id=" + examid.ToString() + ")", con);
                    DataTable dt = new DataTable();
                    sda.Fill(dt);
                    grade = dt.Rows[0][0].ToString();
                    MessageBox.Show("Grade is " + grade + "");

                    Login log = new Login();
                    log.Show();
                    this.Hide();
                    con.Close();
                }
                else
                {
                    MessageBox.Show("Please Enter The Rating And Enter Numbers from 1 to 10 only");
                }

            }
            
        }
    }
}
