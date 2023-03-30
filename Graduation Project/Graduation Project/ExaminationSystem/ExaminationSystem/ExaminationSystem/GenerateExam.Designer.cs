
namespace ExaminationSystem
{
    partial class GenerateExam
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(GenerateExam));
            this.label5 = new System.Windows.Forms.Label();
            this.backgroundWorker1 = new System.ComponentModel.BackgroundWorker();
            this.allquestions = new Guna.UI.WinForms.GunaDataGridView();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.panel7 = new System.Windows.Forms.Panel();
            this.label11 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.enddate = new System.Windows.Forms.DateTimePicker();
            this.startdate = new System.Windows.Forms.DateTimePicker();
            this.button2 = new System.Windows.Forms.Button();
            this.cr_name = new System.Windows.Forms.ComboBox();
            this.mcq = new System.Windows.Forms.TextBox();
            this.tfq = new System.Windows.Forms.TextBox();
            this.q = new System.Windows.Forms.TextBox();
            this.fullmark = new System.Windows.Forms.TextBox();
            this.title = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.gunaCirclePictureBox5 = new Guna.UI.WinForms.GunaCirclePictureBox();
            this.gunaCirclePictureBox1 = new Guna.UI.WinForms.GunaCirclePictureBox();
            this.label14 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.allquestions)).BeginInit();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gunaCirclePictureBox5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gunaCirclePictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Arabic Typesetting", 28.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(553, 338);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(169, 55);
            this.label5.TabIndex = 23;
            this.label5.Text = "Questions";
            this.label5.Click += new System.EventHandler(this.label5_Click);
            // 
            // backgroundWorker1
            // 
            this.backgroundWorker1.DoWork += new System.ComponentModel.DoWorkEventHandler(this.backgroundWorker1_DoWork);
            // 
            // allquestions
            // 
            dataGridViewCellStyle4.BackColor = System.Drawing.Color.White;
            this.allquestions.AlternatingRowsDefaultCellStyle = dataGridViewCellStyle4;
            this.allquestions.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.allquestions.BackgroundColor = System.Drawing.Color.White;
            this.allquestions.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.allquestions.CellBorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.SingleHorizontal;
            this.allquestions.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.None;
            dataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle5.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(88)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle5.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            dataGridViewCellStyle5.ForeColor = System.Drawing.Color.White;
            dataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.allquestions.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5;
            this.allquestions.ColumnHeadersHeight = 4;
            dataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle6.BackColor = System.Drawing.Color.White;
            dataGridViewCellStyle6.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            dataGridViewCellStyle6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(71)))), ((int)(((byte)(69)))), ((int)(((byte)(94)))));
            dataGridViewCellStyle6.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(231)))), ((int)(((byte)(229)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle6.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(71)))), ((int)(((byte)(69)))), ((int)(((byte)(94)))));
            dataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.allquestions.DefaultCellStyle = dataGridViewCellStyle6;
            this.allquestions.EnableHeadersVisualStyles = false;
            this.allquestions.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(231)))), ((int)(((byte)(229)))), ((int)(((byte)(255)))));
            this.allquestions.Location = new System.Drawing.Point(10, 396);
            this.allquestions.Name = "allquestions";
            this.allquestions.RowHeadersVisible = false;
            this.allquestions.RowHeadersWidth = 51;
            this.allquestions.RowTemplate.Height = 24;
            this.allquestions.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.allquestions.Size = new System.Drawing.Size(1255, 277);
            this.allquestions.TabIndex = 22;
            this.allquestions.Theme = Guna.UI.WinForms.GunaDataGridViewPresetThemes.Guna;
            this.allquestions.ThemeStyle.AlternatingRowsStyle.BackColor = System.Drawing.Color.White;
            this.allquestions.ThemeStyle.AlternatingRowsStyle.Font = null;
            this.allquestions.ThemeStyle.AlternatingRowsStyle.ForeColor = System.Drawing.Color.Empty;
            this.allquestions.ThemeStyle.AlternatingRowsStyle.SelectionBackColor = System.Drawing.Color.Empty;
            this.allquestions.ThemeStyle.AlternatingRowsStyle.SelectionForeColor = System.Drawing.Color.Empty;
            this.allquestions.ThemeStyle.BackColor = System.Drawing.Color.White;
            this.allquestions.ThemeStyle.GridColor = System.Drawing.Color.FromArgb(((int)(((byte)(231)))), ((int)(((byte)(229)))), ((int)(((byte)(255)))));
            this.allquestions.ThemeStyle.HeaderStyle.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(88)))), ((int)(((byte)(255)))));
            this.allquestions.ThemeStyle.HeaderStyle.BorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.None;
            this.allquestions.ThemeStyle.HeaderStyle.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.allquestions.ThemeStyle.HeaderStyle.ForeColor = System.Drawing.Color.White;
            this.allquestions.ThemeStyle.HeaderStyle.HeaightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.EnableResizing;
            this.allquestions.ThemeStyle.HeaderStyle.Height = 4;
            this.allquestions.ThemeStyle.ReadOnly = false;
            this.allquestions.ThemeStyle.RowsStyle.BackColor = System.Drawing.Color.White;
            this.allquestions.ThemeStyle.RowsStyle.BorderStyle = System.Windows.Forms.DataGridViewCellBorderStyle.SingleHorizontal;
            this.allquestions.ThemeStyle.RowsStyle.Font = new System.Drawing.Font("Segoe UI", 10.5F);
            this.allquestions.ThemeStyle.RowsStyle.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(71)))), ((int)(((byte)(69)))), ((int)(((byte)(94)))));
            this.allquestions.ThemeStyle.RowsStyle.Height = 24;
            this.allquestions.ThemeStyle.RowsStyle.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(231)))), ((int)(((byte)(229)))), ((int)(((byte)(255)))));
            this.allquestions.ThemeStyle.RowsStyle.SelectionForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(71)))), ((int)(((byte)(69)))), ((int)(((byte)(94)))));
            this.allquestions.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.gunaDataGridView1_CellContentClick);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1347, 687);
            this.panel1.TabIndex = 1;
            this.panel1.Paint += new System.Windows.Forms.PaintEventHandler(this.panel1_Paint);
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.WhiteSmoke;
            this.panel2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.panel2.Controls.Add(this.label13);
            this.panel2.Controls.Add(this.label12);
            this.panel2.Controls.Add(this.label10);
            this.panel2.Controls.Add(this.label9);
            this.panel2.Controls.Add(this.label8);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.panel7);
            this.panel2.Controls.Add(this.label11);
            this.panel2.Controls.Add(this.label7);
            this.panel2.Controls.Add(this.label6);
            this.panel2.Controls.Add(this.enddate);
            this.panel2.Controls.Add(this.startdate);
            this.panel2.Controls.Add(this.label5);
            this.panel2.Controls.Add(this.allquestions);
            this.panel2.Controls.Add(this.button2);
            this.panel2.Controls.Add(this.cr_name);
            this.panel2.Controls.Add(this.mcq);
            this.panel2.Controls.Add(this.tfq);
            this.panel2.Controls.Add(this.q);
            this.panel2.Controls.Add(this.fullmark);
            this.panel2.Controls.Add(this.title);
            this.panel2.Controls.Add(this.label4);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Controls.Add(this.panel3);
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(1365, 734);
            this.panel2.TabIndex = 0;
            this.panel2.Paint += new System.Windows.Forms.PaintEventHandler(this.panel2_Paint);
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label13.Location = new System.Drawing.Point(31, 171);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(141, 32);
            this.label13.TabIndex = 35;
            this.label13.Text = "Course Name:";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label12.Location = new System.Drawing.Point(893, 252);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(219, 32);
            this.label12.TabIndex = 34;
            this.label12.Text = "TF Question Numbers:";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label10.Location = new System.Drawing.Point(893, 203);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(228, 32);
            this.label10.TabIndex = 33;
            this.label10.Text = "MC Question Numbers:";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label9.Location = new System.Drawing.Point(893, 162);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(188, 32);
            this.label9.TabIndex = 32;
            this.label9.Text = "Question Numbers:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label8.Location = new System.Drawing.Point(895, 123);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(155, 32);
            this.label8.TabIndex = 31;
            this.label8.Text = "Exam Fullmark:";
            this.label8.Click += new System.EventHandler(this.label8_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label2.Location = new System.Drawing.Point(31, 123);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(117, 32);
            this.label2.TabIndex = 30;
            this.label2.Text = "Exam Title:";
            // 
            // panel7
            // 
            this.panel7.BackColor = System.Drawing.Color.Black;
            this.panel7.Location = new System.Drawing.Point(360, 80);
            this.panel7.Name = "panel7";
            this.panel7.Size = new System.Drawing.Size(140, 4);
            this.panel7.TabIndex = 29;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.Location = new System.Drawing.Point(354, 45);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(149, 32);
            this.label11.TabIndex = 28;
            this.label11.Text = "Generate Exam";
            this.label11.Click += new System.EventHandler(this.label11_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label7.Location = new System.Drawing.Point(31, 284);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(104, 32);
            this.label7.TabIndex = 27;
            this.label7.Text = "End Date:";
            this.label7.Click += new System.EventHandler(this.label7_Click);
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label6.Location = new System.Drawing.Point(31, 221);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(111, 32);
            this.label6.TabIndex = 26;
            this.label6.Text = "Start Date:";
            this.label6.Click += new System.EventHandler(this.label6_Click);
            // 
            // enddate
            // 
            this.enddate.CalendarForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.enddate.CalendarTitleForeColor = System.Drawing.SystemColors.ActiveBorder;
            this.enddate.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.enddate.Format = System.Windows.Forms.DateTimePickerFormat.Time;
            this.enddate.Location = new System.Drawing.Point(210, 284);
            this.enddate.Name = "enddate";
            this.enddate.Size = new System.Drawing.Size(601, 30);
            this.enddate.TabIndex = 25;
            this.enddate.ValueChanged += new System.EventHandler(this.dateTimePicker2_ValueChanged);
            // 
            // startdate
            // 
            this.startdate.CalendarForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.startdate.CalendarTitleForeColor = System.Drawing.SystemColors.ActiveBorder;
            this.startdate.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.startdate.Format = System.Windows.Forms.DateTimePickerFormat.Time;
            this.startdate.Location = new System.Drawing.Point(210, 223);
            this.startdate.Name = "startdate";
            this.startdate.Size = new System.Drawing.Size(601, 30);
            this.startdate.TabIndex = 24;
            this.startdate.ValueChanged += new System.EventHandler(this.dateTimePicker1_ValueChanged);
            // 
            // button2
            // 
            this.button2.BackColor = System.Drawing.Color.LightGray;
            this.button2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.button2.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.button2.Location = new System.Drawing.Point(959, 309);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(257, 47);
            this.button2.TabIndex = 20;
            this.button2.Text = "Generate Exam";
            this.button2.UseVisualStyleBackColor = false;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // cr_name
            // 
            this.cr_name.Font = new System.Drawing.Font("Arabic Typesetting", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cr_name.ForeColor = System.Drawing.SystemColors.MenuText;
            this.cr_name.FormattingEnabled = true;
            this.cr_name.Location = new System.Drawing.Point(210, 169);
            this.cr_name.Name = "cr_name";
            this.cr_name.Size = new System.Drawing.Size(601, 34);
            this.cr_name.TabIndex = 18;
            this.cr_name.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // mcq
            // 
            this.mcq.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mcq.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.mcq.Location = new System.Drawing.Point(1140, 205);
            this.mcq.Name = "mcq";
            this.mcq.Size = new System.Drawing.Size(89, 30);
            this.mcq.TabIndex = 17;
            this.mcq.TextChanged += new System.EventHandler(this.textBox8_TextChanged);
            // 
            // tfq
            // 
            this.tfq.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tfq.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.tfq.Location = new System.Drawing.Point(1140, 254);
            this.tfq.Name = "tfq";
            this.tfq.Size = new System.Drawing.Size(89, 30);
            this.tfq.TabIndex = 14;
            this.tfq.TextChanged += new System.EventHandler(this.textBox9_TextChanged);
            // 
            // q
            // 
            this.q.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.q.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.q.Location = new System.Drawing.Point(1140, 162);
            this.q.Name = "q";
            this.q.Size = new System.Drawing.Size(86, 30);
            this.q.TabIndex = 9;
            this.q.TextChanged += new System.EventHandler(this.textBox4_TextChanged);
            // 
            // fullmark
            // 
            this.fullmark.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.fullmark.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.fullmark.Location = new System.Drawing.Point(1140, 119);
            this.fullmark.Name = "fullmark";
            this.fullmark.Size = new System.Drawing.Size(86, 30);
            this.fullmark.TabIndex = 7;
            this.fullmark.TextChanged += new System.EventHandler(this.textBox2_TextChanged);
            // 
            // title
            // 
            this.title.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.title.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.title.Location = new System.Drawing.Point(210, 123);
            this.title.Name = "title";
            this.title.Size = new System.Drawing.Size(601, 30);
            this.title.TabIndex = 6;
            this.title.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(703, 44);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(76, 32);
            this.label4.TabIndex = 4;
            this.label4.Text = "Grades";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(566, 45);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(63, 32);
            this.label3.TabIndex = 3;
            this.label3.Text = "Exam";
            this.label3.Click += new System.EventHandler(this.label3_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Book Antiqua", 25.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Firebrick;
            this.label1.Location = new System.Drawing.Point(28, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(265, 51);
            this.label1.TabIndex = 1;
            this.label1.Text = "GENERATE";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // panel3
            // 
            this.panel3.BackColor = System.Drawing.Color.DimGray;
            this.panel3.Controls.Add(this.label14);
            this.panel3.Controls.Add(this.gunaCirclePictureBox5);
            this.panel3.Controls.Add(this.gunaCirclePictureBox1);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel3.ForeColor = System.Drawing.SystemColors.ControlLightLight;
            this.panel3.Location = new System.Drawing.Point(1271, 0);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(90, 730);
            this.panel3.TabIndex = 0;
            this.panel3.Paint += new System.Windows.Forms.PaintEventHandler(this.panel3_Paint);
            // 
            // gunaCirclePictureBox5
            // 
            this.gunaCirclePictureBox5.BaseColor = System.Drawing.Color.White;
            this.gunaCirclePictureBox5.Image = ((System.Drawing.Image)(resources.GetObject("gunaCirclePictureBox5.Image")));
            this.gunaCirclePictureBox5.Location = new System.Drawing.Point(1, 100);
            this.gunaCirclePictureBox5.Name = "gunaCirclePictureBox5";
            this.gunaCirclePictureBox5.Size = new System.Drawing.Size(71, 56);
            this.gunaCirclePictureBox5.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.gunaCirclePictureBox5.TabIndex = 30;
            this.gunaCirclePictureBox5.TabStop = false;
            this.gunaCirclePictureBox5.UseTransfarantBackground = false;
            this.gunaCirclePictureBox5.Click += new System.EventHandler(this.gunaCirclePictureBox5_Click_1);
            // 
            // gunaCirclePictureBox1
            // 
            this.gunaCirclePictureBox1.BaseColor = System.Drawing.Color.White;
            this.gunaCirclePictureBox1.Location = new System.Drawing.Point(21, 24);
            this.gunaCirclePictureBox1.Name = "gunaCirclePictureBox1";
            this.gunaCirclePictureBox1.Size = new System.Drawing.Size(29, 27);
            this.gunaCirclePictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.gunaCirclePictureBox1.TabIndex = 29;
            this.gunaCirclePictureBox1.TabStop = false;
            this.gunaCirclePictureBox1.UseTransfarantBackground = false;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Arabic Typesetting", 16.2F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.Location = new System.Drawing.Point(12, 159);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(50, 32);
            this.label14.TabIndex = 36;
            this.label14.Text = "Exit";
            // 
            // GenerateExam
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1347, 687);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "GenerateExam";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Students";
            ((System.ComponentModel.ISupportInitialize)(this.allquestions)).EndInit();
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.panel3.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gunaCirclePictureBox5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gunaCirclePictureBox1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.Label label5;
        private System.ComponentModel.BackgroundWorker backgroundWorker1;
        private Guna.UI.WinForms.GunaDataGridView allquestions;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.ComboBox cr_name;
        private System.Windows.Forms.TextBox mcq;
        private System.Windows.Forms.TextBox tfq;
        private System.Windows.Forms.TextBox q;
        private System.Windows.Forms.TextBox fullmark;
        private System.Windows.Forms.TextBox title;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.DateTimePicker enddate;
        private System.Windows.Forms.DateTimePicker startdate;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Panel panel7;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label13;
        private Guna.UI.WinForms.GunaCirclePictureBox gunaCirclePictureBox5;
        private Guna.UI.WinForms.GunaCirclePictureBox gunaCirclePictureBox1;
        private System.Windows.Forms.Label label14;
    }
}