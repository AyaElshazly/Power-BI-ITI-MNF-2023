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
    public partial class Exam : Form
    {
        public Exam()
        {
            InitializeComponent();

        }
        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        string[] student_answer = new string[5];
        string[] quest = new string[5];
        

        private void fetchQuestions()
        {
            int examid = Convert.ToInt32(exid.Text);
            int stid = 600;
            string crname = "Theory of Computing";
            try
            {

                con.Open();
                SqlCommand cmd = new SqlCommand("select * from Question where quest_id in (select quest_id from Exam_Question where exam_id ="+ examid.ToString()+ ") order by quest_type", con);
                DataTable dt = new DataTable();
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                sda.Fill(dt);
                int j = 1;

                foreach (DataRow dr in dt.Rows)
                {
                    if (j == 1)
                    {
                        q1.Text = dr["quest_text"].ToString();
                        quest[j - 1] = dr["quest_id"].ToString();

                        SqlCommand cmdd = new SqlCommand("select choise_text from Choise where quest_id=" + dr["quest_id"].ToString() + "", con);
                        DataTable dtt = new DataTable();
                        SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
                        sdaa.Fill(dtt);
                        int i = 1;
                        foreach (DataRow drr in dtt.Rows)
                        {
                            if (i == 1)
                            {
                                a11.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 2)
                            {
                                a12.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 3)
                            {
                                a13.Text = drr["choise_text"].ToString();
                            }
                            else
                            {
                                a14.Text = drr["choise_text"].ToString();
                            }

                            i += 1;
                        }
                    }
                    else if (j == 2)
                    {
                        q2.Text = dr["quest_text"].ToString();
                        quest[j - 1] = dr["quest_id"].ToString();
                        SqlCommand cmdd = new SqlCommand("select choise_text from Choise where quest_id=" + dr["quest_id"].ToString() + "", con);
                        DataTable dtt = new DataTable();
                        SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
                        sdaa.Fill(dtt);
                        int i = 1;
                        foreach (DataRow drr in dtt.Rows)
                        {
                            if (i == 1)
                            {
                                a21.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 2)
                            {
                                a22.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 3)
                            {
                                a23.Text = drr["choise_text"].ToString();
                            }
                            else
                            {
                                a24.Text = drr["choise_text"].ToString();
                            }

                            i += 1;
                        }
                    }
                    else if (j == 3)
                    {
                        q3.Text = dr["quest_text"].ToString();
                        quest[j - 1] = dr["quest_id"].ToString();
                        SqlCommand cmdd = new SqlCommand("select choise_text from Choise where quest_id=" + dr["quest_id"].ToString() + "", con);
                        DataTable dtt = new DataTable();
                        SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
                        sdaa.Fill(dtt);
                        int i = 1;
                        foreach (DataRow drr in dtt.Rows)
                        {
                            if (i == 1)
                            {
                                a31.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 2)
                            {
                                a32.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 3)
                            {
                                a33.Text = drr["choise_text"].ToString();
                            }
                            else
                            {
                                a34.Text = drr["choise_text"].ToString();
                            }

                            i += 1;
                        }
                    }
                    else if (j == 4)
                    {
                        q4.Text = dr["quest_text"].ToString();
                        quest[j - 1] = dr["quest_id"].ToString();
                        SqlCommand cmdd = new SqlCommand("select choise_text from Choise where quest_id=" + dr["quest_id"].ToString() + "", con);
                        DataTable dtt = new DataTable();
                        SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
                        sdaa.Fill(dtt);
                        int i = 1;
                        foreach (DataRow drr in dtt.Rows)
                        {
                            if (i == 1)
                            {
                                a41.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 2)
                            {
                                a42.Text = drr["choise_text"].ToString();
                            }

                            i += 1;
                        }
                    }
                    else
                    {
                        q5.Text = dr["quest_text"].ToString();
                        quest[j - 1] = dr["quest_id"].ToString();
                        SqlCommand cmdd = new SqlCommand("select choise_text from Choise where quest_id=" + dr["quest_id"].ToString() + "", con);
                        DataTable dtt = new DataTable();
                        SqlDataAdapter sdaa = new SqlDataAdapter(cmdd);
                        sdaa.Fill(dtt);
                        int i = 1;
                        foreach (DataRow drr in dtt.Rows)
                        {
                            if (i == 1)
                            {
                                a51.Text = drr["choise_text"].ToString();
                            }
                            else if (i == 2)
                            {
                                a52.Text = drr["choise_text"].ToString();
                            }

                            i += 1;
                        }
                    }

                    j += 1;
                }
                con.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void panel2_Paint(object sender, PaintEventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            fetchQuestions();
        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {
            GenerateExam obj = new GenerateExam();
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void label4_Click(object sender, EventArgs e)
        {
            Grades obj = new Grades();
            obj.Show();
            this.Hide();
            con.Close();
        }
    }
}
