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
    public partial class GenerateExam : Form
    {
        public GenerateExam()
        {
            InitializeComponent();
            getcourse();
        }
        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        private void getcourse()
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("select distinct cr_name from Course order by cr_name", con);
            SqlDataReader rdr;
            rdr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Columns.Add("cr_name", typeof(string));
            dt.Load(rdr);
            cr_name.ValueMember = "cr_name";
            cr_name.DataSource = dt;
            con.Close();
        }
        public static int getid(string cr_name)
        {
            SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
            con.Open();
            SqlCommand cmdd = new SqlCommand("select top 1 cr_id from Course where cr_name='"+cr_name+"'", con);
            DataTable dtt = new DataTable();
            SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
            sdaa.Fill(dtt);
            int x = 1;
            foreach (DataRow drr in dtt.Rows)
            {
                x= Convert.ToInt32(drr["cr_id"].ToString());
            }
            con.Close();
            return x;
        }
        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void panel2_Paint(object sender, PaintEventArgs e)
        {

        }

        private void gunaCirclePictureBox6_Click(object sender, EventArgs e)
        {

        }

        private void gunaCirclePictureBox5_Click(object sender, EventArgs e)
        {

        }

        private void gunaCirclePictureBox4_Click(object sender, EventArgs e)
        {

        }

        private void gunaCirclePictureBox3_Click(object sender, EventArgs e)
        {

        }

        private void gunaCirclePictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {

        }

        private void gunaCirclePictureBox2_Click(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (title.Text == "" || fullmark.Text == "" || cr_name.Text == "" || q.Text == "" || mcq.Text == "" || tfq.Text == "" || startdate.Text == "" || enddate.Text == "")
            {
                MessageBox.Show("Missing Information");
            }
            else
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("examGeneration", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@exam_title", SqlDbType.NVarChar).Value = title.Text;
                    cmd.Parameters.AddWithValue("@exam_fullmark", SqlDbType.Int).Value = Convert.ToInt32(fullmark.Text);
                    cmd.Parameters.AddWithValue("@cr_id", SqlDbType.Int).Value = getid(cr_name.Text);
                    cmd.Parameters.AddWithValue("@exam_startdate", SqlDbType.DateTime).Value = Convert.ToDateTime(startdate.Text);
                    cmd.Parameters.AddWithValue("@exam_enddate", SqlDbType.DateTime).Value = Convert.ToDateTime(enddate.Text);
                    cmd.Parameters.AddWithValue("@questions_numbers", SqlDbType.Int).Value = Convert.ToInt32(q.Text);
                    cmd.Parameters.AddWithValue("@tfNum", SqlDbType.Int).Value = Convert.ToInt32(tfq.Text);
                    cmd.Parameters.AddWithValue("@mcqNum", SqlDbType.Int).Value = Convert.ToInt32(mcq.Text);
                    cmd.ExecuteNonQuery();
                    MessageBox.Show("Exam Generated");
                    string query = "select quest_text as Question,quest_answer as Answer from Question where quest_id in (select quest_id from Exam_Question where exam_id=(select max(exam_id) from Exam))";
                    SqlDataAdapter sda = new SqlDataAdapter(query, con);
                    SqlCommandBuilder builder = new SqlCommandBuilder(sda);
                    var ds = new DataSet();
                    sda.Fill(ds);
                    allquestions.DataSource = ds.Tables[0];
                    con.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox8_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox9_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void panel4_Paint(object sender, PaintEventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {
            Grades obj = new Grades();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void label3_Click(object sender, EventArgs e)
        {
            Exam obj = new Exam();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void gunaDataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void panel3_Paint(object sender, PaintEventArgs e)
        {

        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void dateTimePicker2_ValueChanged(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {
            
        }

        private void dateTimePicker1_ValueChanged_1(object sender, EventArgs e)
        {

        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void label11_Click(object sender, EventArgs e)
        {

        }

        private void gunaCirclePictureBox5_Click_1(object sender, EventArgs e)
        {
            Login obj = new Login();
            obj.Show();
            this.Hide();
            con.Close();
        }
    }
}
