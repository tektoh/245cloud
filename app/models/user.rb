class User < ActiveRecord::Base
  has_many :workloads
  has_many :comments, -> {order('created_at desc')}
  attr_accessor :total

  def workload
    workloads = Workload.where(
      created_at: (Time.now - Workload.pomotime.minutes - 6.minutes)..(Time.now)
    ).where(
      user: self
    )
    workloads.present? ? workloads.first : nil
  end

  def workloads
    Workload.where(
      status: 1,
      user: self
    ).order('created_at desc').limit(24)
  end

  def playing?
    Workload.playings.where(
      user_id: self.id
    ).present?
  end

  def nothing?
    !chatting? && !playing?
  end

  def chatting?
    chatting_workload.present?
  end

  def chatting_workload
    Workload.chattings.where(
      user_id: self.id
    ).order('created_at desc').first
  end

  def self.login data
    auth = Auth.find_or_create_with_omniauth(data)
    auth.user
  end

  def icon
    #"https://ruffnote.com/attachments/24311"
    "https://graph.facebook.com/#{facebook_id}/picture?type=square"
  end

  def facebook_id
    email.split('@').first
  end

  def musics
    MusicsUser.limit(100).order(
      'total desc'
    ).where(
      user_id: self.id
    ).map{|mu| music = mu.music; music.total = mu.total; music}
  end
end

