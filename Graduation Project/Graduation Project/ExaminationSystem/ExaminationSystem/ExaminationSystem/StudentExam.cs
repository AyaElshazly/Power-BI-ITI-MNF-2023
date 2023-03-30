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
    public partial class StudentExam : Form
    {

        public StudentExam(int exid, int sid, string crnam)
        {
            InitializeComponent();
            //MessageBox.Show(exid.ToString() + sid.ToString());
            fetchQuestions(exid,sid,crnam);
            timer1.Enabled = true;
            timer1.Interval = 1000;
        }


        SqlConnection con = new SqlConnection(@"Data Source=.;Initial Catalog=""Examination System"";Integrated Security=True");
        string[] student_answer = new string[5];
        string[] quest = new string[5];
        public string sgrade= "";
        public int examid = 1;
        public int stid = 1;
        public string crname = "";
        

        private void fetchQuestions(int exid, int sid, string crnam)
        {
            examid = exid;
            stid = sid;
            crname = crnam;
            sgrade = "";

            try
            {
                con.Open();

                SqlCommand cmd = new SqlCommand("select * from Question where quest_id in (select quest_id from Exam_Question where exam_id ="+examid.ToString()+") order by quest_type", con);
                DataTable dt = new DataTable();
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                sda.Fill(dt);
                int j = 1;
                
                foreach(DataRow dr in dt.Rows)
                {
                    if (j == 1)
                    {
                        q1.Text = dr["quest_text"].ToString();
                        quest[j-1]= dr["quest_id"].ToString();

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
                    
                    j +=1;
                }
                con.Close();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void checkq1()
        {
            student_answer[0] = "not checked";
            if (a11.Checked)
            {
                student_answer[0] = a11.Text;
            }
            else if (a12.Checked)
            {
                student_answer[0] = a12.Text;
            }
            else if (a13.Checked)
            {
                student_answer[0] = a13.Text;
            }
            else if (a14.Checked)
            {
                student_answer[0] = a14.Text;
            }
        }
        private void checkq2()
        {
            student_answer[1] = "not checked";
            if (a21.Checked)
            {
                student_answer[1] = a21.Text;
            }
            else if (a22.Checked)
            {
                student_answer[1] = a22.Text;
            }
            else if (a23.Checked)
            {
                student_answer[1] = a23.Text;
            }
            else if (a24.Checked)
            {
                student_answer[1] = a24.Text;
            }
        }
        private void checkq3()
        {
            student_answer[2] = "not checked";
            if (a31.Checked)
            {
                student_answer[2] = a31.Text;
            }
            else if (a32.Checked)
            {
                student_answer[2] = a32.Text;
            }
            else if (a33.Checked)
            {
                student_answer[2] = a33.Text;
            }
            else if (a34.Checked)
            {
                student_answer[2] = a34.Text;
            }
        }
        private void checkq4()
        {
            student_answer[3] = "not checked";
            if (a41.Checked)
            {
                student_answer[3] = a41.Text;
            }
            else if (a42.Checked)
            {
                student_answer[3] = a42.Text;
            }
        }
        private void checkq5()
        {
            student_answer[4] = "not checked";
            if (a51.Checked)
            {
                student_answer[4] = a51.Text;
            }
            else if (a52.Checked)
            {
                student_answer[4] = a52.Text;
            }
        }
        private void submitanswers(int stid,int examid,string qid,string answer)
        {
            //MessageBox.Show(qid);
            con.Open();
            SqlCommand cmd = new SqlCommand("examAnswer", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@student_Id", SqlDbType.Int).Value = stid;
            cmd.Parameters.AddWithValue("@exam_Id", SqlDbType.Int).Value = examid;
            cmd.Parameters.AddWithValue("@question_ID", SqlDbType.Int).Value = Convert.ToInt32(qid);
            cmd.Parameters.AddWithValue("@Student_Answer", SqlDbType.NVarChar).Value = answer;
            cmd.ExecuteNonQuery();
            con.Close();
        }
        private void correctanswers(int stid, int examid)
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("examCorrection", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@examID", SqlDbType.Int).Value = examid;
            cmd.Parameters.AddWithValue("@studentID", SqlDbType.Int).Value = stid;
            cmd.ExecuteNonQuery();
            con.Close();
        }
        private void countgrade(int stid, int examid)
        {
            con.Open();
            string query = "SELECT Student_Course.grade FROM Exam INNER JOIN Student_Course ON Exam.cr_id = Student_Course.cr_id where exam_id="+examid.ToString()+" and st_id="+stid.ToString();
            SqlDataAdapter sda = new SqlDataAdapter(query, con);
            SqlCommandBuilder builder = new SqlCommandBuilder(sda);
            var ds = new DataSet();
            sda.Fill(ds);
            sgrade=(ds.Tables[0].Rows[0][0]).ToString();
            //MessageBox.Show(sgrade);
            con.Close();
        }
        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void groupBox4_Enter(object sender, EventArgs e)
        {

        }

        private void radioButton11_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void radioButton15_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void panel2_Paint(object sender, PaintEventArgs e)
        {
            //timer1.Start();
        }
    

        private void StudentExam_Load(object sender, EventArgs e)
        {
            
        }

        private void backgroundWorker2_DoWork(object sender, DoWorkEventArgs e)
        {

        }

        int h=0,m=59,s=59;
        int score = 0;
        private void submit_Click(object sender, EventArgs e)
        {
            checkq1();
            checkq2();
            checkq3();
            checkq4();
            checkq5();
            submitanswers(stid, examid, quest[0], student_answer[0]);
            submitanswers(stid, examid, quest[1], student_answer[1]);
            submitanswers(stid, examid, quest[2], student_answer[2]);
            submitanswers(stid, examid, quest[3], student_answer[3]);
            submitanswers(stid, examid, quest[4], student_answer[4]);
            correctanswers(stid,examid);
            countgrade(stid,examid);
            timer1.Enabled = false;
            Rating obj = new Rating(examid,stid,sgrade);
            obj.Show();
            this.Hide();
            con.Close();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            s -= 1;
            if (s == 0)
            {
                s = 59;
                m -= 1;
            }
            if (m == -1)
            {
                timer1.Enabled = false;
                MessageBox.Show("Time is Over");
                this.Hide();
                Login log = new Login();
            }
            time.Text = string.Format("{0}:{1}:{2}", h.ToString().PadLeft(2, '0'), m.ToString().PadLeft(2, '0'), s.ToString().PadLeft(2, '0'));

        }

        private void q3_Enter(object sender, EventArgs e)
        {

        }
    }
}
