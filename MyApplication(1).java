package com.tpe.main;

import com.tpe.domain.Message;
import com.tpe.service.MailService;

public class MyApplication {

	public static void main(String[] args) {
		
		Message message=new Message();
		message.setMessage("Order was sent");
		
		MailService mailService=new MailService();
		mailService.sendMessage(message);

	}

