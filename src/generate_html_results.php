<?php
    $ubi_color = $argv[1];
    echo "<html><body>\n";
    echo "<font color=#bb0000>Prediction results of ESA-UbiSite: </font><br>\n";
    $class = array("<font color=#777777>N</font>", "Y");
    $bgc = array("<tr bgcolor=#eeeeee>","<tr bgcolor=#ffeeee>");
    $sfp = fopen($ubi_color,"r");
    $start = 1;
    while(!feof($sfp)){
    		$seq = trim(fgets($sfp,99999));
        if(isset($seq[0])){
             if($seq[0] == ">"){
      			     if($start == 1){
      				       $start = 0;
      			     }else{
      				       echo "</table>";
      			     }
      			     echo "<hr>";
      			     echo "<table>";
      			     echo "<tr bgcolor=#eeffee><td colspan=4><u>".$seq."</u></td></tr>";
      		    }elseif($seq[0] == "="){
      			      $all_seq = substr($seq,1);
      			      echo "<tr bgcolor=#eeeeff><td colspan=4><tt>".$all_seq."</tt></td></tr>";
      			      echo "<tr bgcolor=#f0fefe><td>Position</td><td>Sequence</td><td>Ubiquitination</td><td>Score</td></tr><tr></tr>";
      		    }else{
      			      $list = explode("\t",$seq);
                  if(isset($list[0], $list[3])){
                      $seq = $list[1];
                      $position = $list[0];
                      $dec_value = $list[3];
                      if($dec_value > 0.51){
                          $predict = 1;
                      }
                      else{
                        $predict = 0;
                      }
                       

                    if($seq != ""){
                    #echo "$bgc[$predict]<td>$position</td><td>$seq</td><td>$class[$predict]</td>";
                    if($predict == 1){
                        printf("%s<td><b>%d</b></td><td><b><tt>%s</tt></br></td><td><b>%s</b></td><td><b>%.2f</b></td></tr>", $bgc[$predict], $position, $seq, $class[$predict], $dec_value);
                    }else{
                        printf("%s<td>%d</td><td><tt>%s</tt></td><td>%s</td><td>%.2f</td></tr>", $bgc[$predict], $position, $seq, $class[$predict], $dec_value);
                    }
                //echo "The imunogenic level of sequence \"<font color=#995500>".$seq;
                //echo "</font>\" is <font color=#005599>".$class[$kind]."</font><BR>";
              }
            }

      		}
        }

    	}
    	fclose($sfp);
      echo "</table>\n";
      echo "</body></html>\n";
