module tb;
  
  parameter DW=8;
  
  reg clk;
  
  reg resetn;
  
  reg [DW-1:0] s_data0;
  
  reg s_valid0;
  
  reg s_last0;
  
  wire s_ready0;

  
  reg [DW-1:0] s_data1;
  
  reg s_valid1;
  
  reg s_last1;
  
  wire s_ready1;
  
  reg sel;
  
  reg m_ready;
  
  wire [DW-1:0] m_data;
  
  wire m_valid;
  
  wire m_last;
  
  
  event ev;
  
  event ev1;
  
  
  
  
  
  mux_axi uut(clk,resetn,s_data0,s_valid0,s_last0,s_ready0,s_data1,s_valid1,s_last1,s_ready1,sel,m_data,m_valid,m_last,m_ready);
  
  initial begin
    	
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    $dumpfile("file.vcd");
    $dumpvars;
  end
  
  initial begin
    
    resetn=0;
    #10;
    resetn=1;
    
    fork 
      begin
      	m_ready_generate;
        wait(ev.triggered);
        m_ready<=1;
        wait(ev1.triggered);
        m_ready<=0;
        #20;
        m_ready<=1;
      end 
    /*  begin
      select1;
        wait(ev.triggered);
      select0; 
      end  */
      begin
      axi_stream_generate(10);
        #100;
        ->ev;
        axi_stream_generate(14);
        ->ev1;
        axi_stream_generate(1);
      end
  
        
    join
  end
  
  task m_ready_generate;
    
    begin
      repeat(20) 
          @(posedge clk)
          	m_ready=$random;
    end
  endtask
  
  
  initial begin
    #600;
    $finish;
  end
  
  
  initial begin
     select1;
    
    #250;
    
    select0;
    
  end
  
  
  
  task select1;
    	
    begin
      	sel=1;
    end
   endtask
      
      task select0;
    	
    begin
      	sel=0;
    end
   endtask
  
  
  task axi_stream_generate(input [3:0] count);
    	begin
          repeat(count-1)
            	begin
                  if(sel)
                    	begin
                          while(m_ready==0)
                            @(posedge clk);
                          
                          @(posedge clk)
                          
                  			s_data1<=$random;
                          	s_valid1<=1;
                          	s_last1<=0;
                        end
                  else
                        begin
                          while(m_ready==0)
                            @(posedge clk);
                          
                          @(posedge clk)
                  			s_data0<=$random;
                          	s_valid0<=1;
                          	s_last0<=0;
                        end
                end
          	 @(posedge clk);
          if(sel) begin
                  			s_data1<=$random;
                          	s_valid1<=1;
                          	s_last1<=1;
            				while(m_ready==0)
                            @(posedge clk);
          end
          else
            		begin
                      		s_data0<=$random;
                          	s_valid0<=1;
                          	s_last0<=1;
                      		while(m_ready==0)
                            @(posedge clk);
                    end  	
             @(posedge clk);
                          
            if(sel) begin
                  			s_data1<=0;
                          	s_valid1<=0;
                          	s_last1<=0;
     
          end
          else
            		begin
                      		s_data0<=0;
                          	s_valid0<=0;
                          	s_last0<=0;
                      		
                    end 
        end
    
  endtask
 
  
endmodule
  
          
                    	
                  
                  
          	
  
  
    
    
  
  
  